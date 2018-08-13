//
//  NIMGroupAgreeVC.m
//  qbim
//
//  Created by 秦雨 on 17/3/16.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupAgreeVC.h"
#import "NIMVcardCollectionViewCell.h"
#import "NIMSelfViewController.h"
#import "NIMGroupOperationBox.h"
@interface NIMGroupAgreeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,VcardCollectionViewCellDelegate>
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *desc;
@property(nonatomic,strong)UILabel *reason;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *memberDatasource;


@end

@implementation NIMGroupAgreeVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"邀请详情";
    [self makeConstraints];
    
    [self.collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:kvcardIdentifier];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:NC_GROUP_ENTER_AGREE object:nil];
}

-(void)updateData
{
    NSArray *userids =[NSJSONSerialization JSONObjectWithData:[self.chatEntity.sendUserName dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSString *reasonStr = self.chatEntity.msgContent;
    
    self.reason.text = reasonStr;
    
    self.memberDatasource = userids;
    
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:self.chatEntity.userId];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:vcard.avatar] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    self.name.text = [vcard defaultName];
    self.desc.text = [NSString stringWithFormat:@"邀请%lu位朋友进群",(unsigned long)userids.count];
    int type = self.chatEntity.stype;
    if (type==GROUP_NEED_AGREE) {
        [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        [self.sureBtn setTitle:@"已确认" forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor lightGrayColor];
        self.sureBtn.userInteractionEnabled = NO;
    }
    
    NSLog(@"userids:%@",userids);
}

-(void)changeStatus:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            [self.sureBtn setTitle:@"已确认" forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = [UIColor lightGrayColor];
            self.sureBtn.userInteractionEnabled = NO;
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBTip showTipsView:@"申请失败" atView:self.view];
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)makeConstraints{
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).with.offset(5);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.desc mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).with.offset(10);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.reason mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desc.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.line.mas_top).with.offset(-10);
    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);

    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
        make.top.equalTo(self.line.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).with.offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-20);
        
    }];
    [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).with.offset(10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numerOfItems = 0;
    numerOfItems = self.memberDatasource.count;
    return numerOfItems;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kvcardIdentifier forIndexPath:indexPath];
    cell.vcardDelegate = self;
    [self configCollectionViewCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *imageStr = nil;
    
    if (indexPath.row < self.memberDatasource.count)
    {
        NSDictionary *dict = [self.memberDatasource objectAtIndex:indexPath.row];
        int64_t userid = [[dict objectForKey:@"userid"] longLongValue];
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:userid];
        cell.uid = userid;
        imageStr = vcardEntity.avatar;
        [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
        [cell updateConstraints];
        
//        cell.vcardDelegate = self;
        
        cell.lbIsGroupMaster.hidden = YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (self.view.frame.size.width-70)/6.0;
    if (height>45) {
        height = 45;
    }
    return CGSizeMake(height, height);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

-(void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIButton *)avatar
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *dict = [self.memberDatasource objectAtIndex:indexPath.row];
    int64_t userid = [[dict objectForKey:@"userid"] longLongValue];
    [self showProfileControllerWithUserid:userid];

}


- (void)showProfileControllerWithUserid:(int64_t)userid{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType =ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
    }
}

-(void)sureClick:(id)sender
{
    NSMutableArray *userInfos = @[].mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    [self.memberDatasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = obj;
        QBUserBaseInfo *info = [[QBUserBaseInfo alloc] init];
        info.user_id = [[dict objectForKey:@"userid"] longLongValue];
        info.user_nick_name = [dict objectForKey:@"nick"];
        [userInfos addObject:info];
    }];
    [[NIMGroupOperationBox sharedInstance] sendGroupAddUserinfos:userInfos groupid:self.chatEntity.groupId opUserid:self.chatEntity.opUserId oldMsgid:self.chatEntity.messageId reason:nil];
}

#pragma mark
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.contentMode = UIViewContentModeScaleAspectFill;
        _sureBtn.clipsToBounds = YES;
        _sureBtn.layer.cornerRadius = 2;
        _sureBtn.backgroundColor = [SSIMSpUtil getColor:@"57BD9D"];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sureBtn];
    }
    return _sureBtn;
}


-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:nil];
        _icon.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _icon.backgroundColor = [SSIMSpUtil getColor:@"e6e6e6"];
        _icon.image = [UIImage imageNamed:@"icon_point_head.png"];
        [self.view addSubview:_icon];
    }
    return _icon;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        _name.numberOfLines = 1;
        _name.font = [UIFont systemFontOfSize:14];
        _name.textColor = [UIColor lightGrayColor];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.text = @"那看你了";
        [self.view addSubview:_name];
    }
    return _name;
}
-(UILabel *)desc{
    if (!_desc) {
        _desc = [[UILabel alloc] initWithFrame:CGRectZero];
        _desc.numberOfLines = 1;
        _desc.font = [UIFont systemFontOfSize:16];
        _desc.textColor = [UIColor blackColor];
        [self.view addSubview:_desc];
    }
    return _desc;
}

-(UILabel *)reason
{
    if (!_reason) {
        _reason = [[UILabel alloc] initWithFrame:CGRectZero];
        _reason.numberOfLines = 3;
        _reason.font = [UIFont systemFontOfSize:17];
        _reason.textColor = [UIColor blackColor];
        _reason.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_reason];
    }
    return _reason;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIImageView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [SSIMSpUtil getColor:@"e6e6e6"];
        [self.view addSubview:_line];
    }
    return _line;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        //同一行相邻两个cell的最小间距
        layout.minimumInteritemSpacing = 5;
        //最小两行之间的间距
        layout.minimumLineSpacing = 5;

        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
@end
