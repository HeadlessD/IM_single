//
//  DFVideoSendViewController.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/11.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "DFVideoSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "NIMMomentsManager.h"
#import "NIMManager.h"

#import "NIMSelectBlackListVC.h"
#import "DFModifyViewController.h"
#import <DFVideoPlayController.h>

#import "UIImage+NIMEffects.h"
#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7
@interface DFVideoSendViewController ()<DFPlainGridImageViewDelegate,NIMSelectBlackListVCDelegate,DFModifyViewControllerDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate,DFVideoDecoderDelegate>

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) UILabel *placeholder;

@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UILabel *modifyL;


@property (nonatomic, strong) UIImageView *videoView;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) DFVideoLineItem *textVideoItem;
@property (nonatomic, assign) Moments_Priv_Type type;
@property (nonatomic, strong) NSString *list;
@property (nonatomic, strong) DFVideoDecoder *decorder;

@end

@implementation DFVideoSendViewController

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    _textVideoItem = nil;
    [_mask removeGestureRecognizer:_panGestureRecognizer];
    [_mask removeGestureRecognizer:_tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _type = Moments_Priv_Type_Pub;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSendArticle:) name:NC_SEND_ARTICLE object:nil];
    
}

-(void) initView
{
    
    self.view.backgroundColor = COLOR_RGB(237, 237, 237);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat x, y, width, heigh;
    x=0;
    y=74;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    //_contentView.layer.borderColor = [UIColor redColor].CGColor;
    //_contentView.layer.borderWidth =2;
    [self.view addSubview:_contentView];
    
    //placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(x+5, y+5, 150, 25)];
    _placeholder.text = @"这一刻的想法...";
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.enabled = NO;
    [self.view addSubview:_placeholder];
    
    
    _videoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo:)];
    [_videoView addGestureRecognizer:tap];
    _videoView.userInteractionEnabled = YES;
    [self.view addSubview:_videoView];
    
    
    _mask = [[UIView alloc] initWithFrame:self.view.bounds];
    _mask.backgroundColor = [UIColor clearColor];
    _mask.hidden = YES;
    [self.view addSubview:_mask];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_tapGestureRecognizer];
    [self refreshGridImageView];
}

-(void) refreshGridImageView
{
    CGFloat x, y, width, heigh;
    x=10;
    y = CGRectGetMaxY(_contentView.frame)+10;
    width  = (ScreenWidth-20)/3;
    heigh = width*1.3;

    if (_localPath != nil) {
        [self decodeVideo];
    }
    
    _videoView.frame = CGRectMake(x, y, width, heigh);
    
    CGFloat btnY = heigh==0?y:y+heigh+10;
    self.modifyBtn.frame = CGRectMake(0, btnY, self.view.frame.size.width, 50);
    self.modifyL.frame = CGRectMake(SCREEN_WIDTH-110, btnY, 100, 50);
}

-(void) decodeVideo
{
    
    if (_videoView.image == nil) {
        _videoView.image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:_localPath]];
    }
    /*
    if (_decorder == nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DFVideoDecoder *decoder = [[DFVideoDecoder alloc] initWithFile:_localPath];
            decoder.delegate = self;
            _decorder = decoder;
            [decoder decode];
        });
    }else{
        [self onDecodeFinished];
    }*/
}

-(void)onDecodeFinished
{
    //解码完成 刷新界面
    NSLog(@"解码完成");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_decorder.animation != nil) {
            [_videoView.layer removeAnimationForKey:@"contents"];
            [_videoView.layer addAnimation:_decorder.animation forKey:nil];
            
        }
    });
}

- (void)onTapVideo:(UIGestureRecognizer *) gesture {
    DFVideoPlayController *playController = [[DFVideoPlayController alloc] initWithFile:_localPath];
    [self presentViewController:playController animated:YES completion:nil];
}



-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"取消" selector:@selector(cancel) target:self];
}

-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem text:@"发送" selector:@selector(send) target:self];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) send
{
    if (_localPath == nil) {
        [MBTip showTipsView:@"请输入这一刻的想法" atView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _textVideoItem = [[NIMMomentsManager sharedInstance] createVideoItem:_contentView.text videoPath:_localPath screenShot:_screenShot];
    _textVideoItem.priType = _type;
    if (_type == Moments_Priv_Type_White) {
        _textVideoItem.whiteList = _list;
    }else if (_type == Moments_Priv_Type_Black) {
        _textVideoItem.blackList = _list;
    }
    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
    
    dispatch_group_enter(group);
    [[NIMManager sharedImManager] postFile:[NSURL fileURLWithPath:_localPath] userid:OWNERID toId:0 msgid:_textVideoItem.itemId fileType:FILE_TYPE_VIDEO completeBlock:^(id object, NIMResultMeta *result) {
        if (result) {
            
        }else{
            NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
            [images addObject:url];
            
            NSFileManager * manager = [NSFileManager defaultManager];
            BOOL isDir = YES;
            NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:url]];
            if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
                [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSError *error;
            if ([manager moveItemAtPath:_localPath toPath:filePath error:&error]) {
                _textVideoItem.localVideoPath = filePath;
            }
            
//            NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:url]];
//            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:url];
            _textVideoItem.videoUrl = url;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [[NIMManager sharedImManager] postFile:_screenShot userid:OWNERID toId:0 msgid:_textVideoItem.itemId fileType:FILE_TYPE_IMAGE completeBlock:^(id object, NIMResultMeta *result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (result) {
            
        }else{
            NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
            [images addObject:url];
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:url]];
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:url];
            _textVideoItem.videoUrl = url;
        }
        dispatch_group_leave(group);
    }];
    /*
    [[NIMManager sharedImManager] uploadArticle:_screenShot articleId:_textVideoItem.itemId index:0 completeBlock:^(id object, NIMResultMeta *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
            [images addObject:url];
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:url]];
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:url];
            _textVideoItem.thumbUrl = url;
        }else{
        }
        // 发送信号量
        dispatch_group_leave(group);
    }];*/
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (images.count>1) {
                _textVideoItem.content = [images componentsJoinedByString:@"#"];
                [[NIMMomentsManager sharedInstance] sendMomentsArticleRQ:_textVideoItem];
            } else {
                [MBTip showTipsView:@"朋友圈发送失败，请重新尝试" atView:self.view];
            }
        });
        
    });
    
    
    /*
    [[NIMManager sharedImManager] postFile:[NSURL fileURLWithPath:_localPath] userid:OWNERID toId:0 msgid:_textVideoItem.itemId fileType:FILE_TYPE_VIDEO completeBlock:^(id object, NIMResultMeta *result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (result) {
            
        }else{
            NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
            _textVideoItem.content = url;
            NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:url]];
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:url];
            [[NIMMomentsManager sharedInstance] sendMomentsArticleRQ:_textVideoItem];
        }
    }];
*/
    
    
}

-(void)recvSendArticle:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
            return;
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(onSendTextVideoItem:)]) {
                int64_t itemId = [object longLongValue];
                if (_textVideoItem.itemId == itemId) {
                    [_delegate onSendTextVideoItem:_textVideoItem];
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:nil];
    }
}


-(void) onPanAndTap:(UIGestureRecognizer *) gesture
{
    _mask.hidden = YES;
    [_contentView resignFirstResponder];
}



#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeholder.hidden = YES;
    }else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholder.hidden = NO;
        
    }
    //    if ([text isEqualToString:@"\n"]){
    //        _mask.hidden = YES;
    //        [_contentView resignFirstResponder];
    //        if (range.location == 0)
    //        {
    //            _placeholder.hidden = NO;
    //        }
    //        return NO;
    //    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _mask.hidden = NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _mask.hidden = YES;
}


#pragma mark - DFModifyViewControllerDelegate

-(void)modifyViewController:(DFModifyViewController *)viewController didSelectPriType:(Moments_Priv_Type)type users:(NSArray *)users
{
    NSArray *arr = @[@"公开",@"私密",@"部分可见",@"不给谁看"];
    _type = type;
    _list = [users componentsJoinedByString:@","];
    self.modifyL.text = arr[_type-1];
}

-(void)modify
{
    DFModifyViewController *blackList = [[DFModifyViewController alloc] init];
    blackList.delegate = self;
    blackList.index = _type-1;
    [self.navigationController pushViewController:blackList animated:YES];
}

-(UIButton *)modifyBtn
{
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_modifyBtn setTitle:@"谁可以看" forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _modifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _modifyBtn.backgroundColor = [UIColor whiteColor];
        _modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _modifyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_modifyBtn addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_modifyBtn];
    }
    return _modifyBtn;
}

-(UILabel *)modifyL
{
    if (!_modifyL) {
        _modifyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _modifyL.font = [UIFont systemFontOfSize:15];
        _modifyL.backgroundColor = [UIColor whiteColor];
        _modifyL.text = @"全部";
        _modifyL.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_modifyL];
    }
    return _modifyL;
}


@end
