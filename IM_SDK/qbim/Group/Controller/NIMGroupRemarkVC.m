//
//  NIMGroupRemarkVC.m
//  qbim
//
//  Created by 秦雨 on 17/4/27.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupRemarkVC.h"
#import "NIMPlaceholderTextView.h"
#import "NIMRemarkBottomView.h"
#import "NIMRemarkLabel.h"
#define MColor(a, g, b) [UIColor colorWithRed:(a / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1]

@interface NIMGroupRemarkVC ()<UITextViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)NIMPlaceholderTextView *textView;
@property(nonatomic,strong)NIMRemarkBottomView *bottomView;
@property(nonatomic,strong)NIMRemarkLabel *contentLabel;
@property(nonatomic,assign)CGFloat height;

@end

@implementation NIMGroupRemarkVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"群公告"];
    [self createView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvRemarkChange:) name:NC_GROUP_REMARK_MODIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvRemarkDetail:) name:NC_GROUP_REMARK_DETAIL object:nil];
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    CGSize rect = [self.remark boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    _height = rect.height;
    
    CGFloat offsetY = CGRectGetMinY(self.bottomView.frame) - (CGRectGetMaxY(self.icon.frame)+25);

    
    if (offsetY < _height) {
        self.bottomView.frame = CGRectMake(20, CGRectGetMaxY(self.contentLabel.frame)+10, SCREEN_WIDTH-40, 30);
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bottomView.frame)+30);
    }
    self.contentLabel.text = self.remarkEntity.content;
    self.textView.text = self.remarkEntity.content;
    [self setData];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setData
{
    [self.contentLabel removeFromSuperview];
    [self.textView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    if (self.remarkEntity&&!IsStrEmpty(self.remarkEntity.content)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:USER_ICON_URL(self.remarkEntity.userid)] placeholderImage:[UIImage imageNamed:@"fclogo"]];
        self.nameLabel.text = [self getPriorNameWithGroup:self.groupid userid:self.remarkEntity.userid];
        self.timeLabel.text = [SSIMSpUtil timeWithTimeInterval:self.remarkEntity.ct];
        [self.scrollView addSubview:self.icon];
        [self.scrollView addSubview:self.nameLabel];
        [self.scrollView addSubview:self.timeLabel];
        [self.scrollView addSubview:self.line];
        [self.scrollView addSubview:self.contentLabel];
        if (self.isLeader) {
            [self qb_showRightButton:@"编辑"];
        }else{
            [self.scrollView addSubview:self.bottomView];
        }
    }else{
        [self qb_showRightButton:@"完成"];
        self.rightButton.enabled = NO;
        [self.icon removeFromSuperview];
        self.icon.frame = CGRectZero;
        [self.nameLabel removeFromSuperview];
        [self.timeLabel removeFromSuperview];
        [self.line removeFromSuperview];
        [_scrollView removeFromSuperview];
        self.textView.editable = YES;
        self.textView.frame = CGRectMake(10, CGRectGetMaxY(self.icon.frame)+25, SCREEN_WIDTH-20, SCREEN_HEIGHT-CGRectGetMaxY(self.icon.frame)-30);
        [self.view addSubview:self.textView];
    }
}

-(void)qb_rightButtonAction
{
    [self.contentLabel removeFromSuperview];
    [self.textView removeFromSuperview];
    _scrollView.contentSize = CGSizeZero;
    [self.view addSubview:self.textView];
    self.textView.editable = YES;
    if ([self.rightButton.currentTitle isEqualToString:@"完成"]) {
        
        [self.textView resignFirstResponder];
        
        if ([self.textView.text isEqualToString:self.remarkEntity.content]) {
            [MBTip showTipsView:@"请修改群公告内容" atView:self.view];
            return;
        }
        if (self.textView.text.length >500) {
            [MBTip showTipsView:@"超过字数上限" atView:self.view];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否发布该公告？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            [[NIMGroupOperationBox sharedInstance] changeGroupInfo:self.groupid content:self.textView.text type:GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK];
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancle];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self qb_showRightButton:@"完成"];
    }
}


- (void)createView {
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 + IPX_TOP_SAFE_H, SCREEN_WIDTH, SCREEN_HEIGHT - IPX_BOTTOM_SAFE_H)];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    _scrollView.bounces = NO;
    
}


-(NSString *)getPriorNameWithGroup:(int64_t)groupid userid:(int64_t)userid
{
    NSString *priorName = nil;
    GroupList *groupEntity = [GroupList instancetypeFindGroupId:groupid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(messageBodyId = %@) AND (userid = %@)",groupEntity.messageBodyId,@(userid)];
    FDListEntity *fd = [FDListEntity instancetypeFindFriendId:userid];
    GMember *member = [GMember NIM_findFirstWithPredicate:predicate];
    VcardEntity *card = [VcardEntity instancetypeFindUserid:userid];
    
    
    if (!IsStrEmpty(fd.fdRemarkName)) {
        priorName = fd.fdRemarkName;
    }else{
        if (member) {
            priorName = IsStrEmpty([member groupmembernickname])? card.defaultName:[member groupmembernickname];
        }else{
            priorName = card.defaultName;
        }
        
    }
    return priorName;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.remarkEntity.content]) {
        self.rightButton.enabled = NO;
    }else{
        self.rightButton.enabled = YES;
    }
}


-(void)recvRemarkChange:(NSNotification *)notification
{
    id object = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    if (!object) {
         UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
}

#pragma mark ---- 根据键盘高度将当前视图向上滚动同样高度
///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.textView.frame = CGRectMake(10, CGRectGetMaxY(self.icon.frame)+25, SCREEN_WIDTH-20, SCREEN_HEIGHT-CGRectGetMaxY(self.icon.frame)-30-offset);
        }];
    }
}
#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = CGRectMake(10, CGRectGetMaxY(self.icon.frame)+25, SCREEN_WIDTH-20, SCREEN_HEIGHT-CGRectGetMaxY(self.icon.frame)-30);
    }];
}


-(void)recvRemarkDetail:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    id object = notification.object;
    if (!object) {
        
        UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithOnlyTitle:@"无法修改群公告，可稍后再试"];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showError:param.p_string toView:self.view];
            });
        }else{
            NSDictionary *dict = object;
            int64_t ct = [[dict objectForKey:@"ct"] longLongValue];
            int64_t userid = [[dict objectForKey:@"userid"] longLongValue];
            NSString *reamrk = [dict objectForKey:@"reamrk"];
            RemarkEntity *remarkEntity = [RemarkEntity instancetypeFindgroupid:self.groupid];
            if (!remarkEntity) {
                remarkEntity = [RemarkEntity NIM_createEntity];
                remarkEntity.groupid = self.groupid;
            }
            remarkEntity.userid = userid;
            remarkEntity.content = reamrk;
            remarkEntity.ct = ct;
            self.remarkEntity = remarkEntity;
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setData];
            });
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80,40,40)];

    }
    return _icon;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+5, 75, SCREEN_WIDTH-70, 20)];
        _nameLabel.textColor = [UIColor grayColor];

    }
    return _nameLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+5, CGRectGetMaxY(self.nameLabel.frame)+10, SCREEN_WIDTH-70, 15)];
        _timeLabel.textColor = [UIColor grayColor];

    }
    return _timeLabel;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.icon.frame)+20, SCREEN_WIDTH-20, 1)];
        _line.backgroundColor = MColor(215, 215, 215);
    }
    return _line;
}

-(NIMPlaceholderTextView *)textView
{
    if (!_textView) {
        _textView = [[NIMPlaceholderTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.icon.frame)+25, SCREEN_WIDTH-20, SCREEN_HEIGHT-CGRectGetMaxY(self.icon.frame)-60)];
        _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.placeholderColor = MColor(0x89, 0x89, 0x89);
        _textView.placeholder = @"请编辑群公告";
//        [self.view addSubview:_textView];
    }
    return _textView;
}


-(NIMRemarkBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[NIMRemarkBottomView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60, SCREEN_WIDTH-40, 30)];
    }
    return _bottomView;
}

-(NIMRemarkLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[NIMRemarkLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.icon.frame)+25, SCREEN_WIDTH-20, _height)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font=[UIFont systemFontOfSize:18];

    }
    return _contentLabel;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
