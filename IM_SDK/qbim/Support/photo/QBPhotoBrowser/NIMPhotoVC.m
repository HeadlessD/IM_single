//
//  NIMPhotoVC.m
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  整体控制器

#import "NIMPhotoVC.h"
#import "NIMPhotoView.h"
#import "NIMLatestVcardViewController.h"
//#import "MessageNIMOperationBox.h"
#import "ALAssetsLibrary+NIMCustomPhotoAlbum.h"
#import "NIMMessageCenter.h"
@interface NIMPhotoVC ()<NIMPhotoViewDelegate,VcardForwardDelegate>

@property (nonatomic, strong) UIButton* btnBack;
@property (nonatomic, strong) UIButton* btnDelete;
@property (nonatomic, assign) UIStatusBarStyle oldStyle;
@end

@implementation NIMPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _oldStyle = [UIApplication sharedApplication].statusBarStyle;

    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenSelf) name:@"HIDDENQBPHOTOBROWSER" object:nil];
    
    // Do any additional setup after loading the view.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:展示图片展示
- (void)showBrowser
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    self.view.alpha = 0;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
//    [keyWindow addSubview:self.view];
//    [keyWindow.rootViewController addChildViewController:self];
    [keyWindow.rootViewController presentViewController:self animated:YES completion:nil];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                     }];
}

- (void)hiddenSelf
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [UIApplication sharedApplication].statusBarStyle = _oldStyle;
    [UIView animateWithDuration:0.3
                     animations:^{
//                         self.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self hiddenAndDelay];
                     }];
}

- (void)hiddenAndDelay{
    if([UIApplication sharedApplication].keyWindow.userInteractionEnabled)
        return;
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    if(_delegate && [_delegate respondsToSelector:@selector(deletePhontCallBack:)])
    {
        if(self.photoObjects.count>0)
            [_delegate deletePhontCallBack:self.photoObjects];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self removeFromParentViewController];
    self.scrolView.delegate = nil;
}

- (void)shareToFriend:(id)imageUrl messageId:(int64_t)messageId{
    DBLog(@"%lld",messageId);
    
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.delegate = self;
        latestVVC.objectForward = @(messageId);
    }
    [self presentViewController:latestVcardNavigation animated:YES completion:^{
    }];
//    [self.view addSubview:latestVcardNavigation.view];
//    [self addChildViewController:latestVcardNavigation];
}

- (void)saveImageToAlbum:(UIImage *)image{
    [self saveImageToAlbum:image withAlert:YES];
}

- (void)saveImageToAlbum:(UIImage*)image withAlert:(BOOL)alert{
    if(image)
    {
        void(^callback)();
        callback= ^(){
            ALAssetsLibrary* lib = [[ALAssetsLibrary alloc] init];
            [lib nim_saveImage:image
                   toAlbum:@"钱宝" withCompletionBlock:^(NSError *error) {
                       NSString* message = @"";
                       if (error) {
                           if(error.code == -3310 ||
                              error.code == -3311)
                           {
                               message = @"请允许“钱宝”访问图片库";
                           }
                           else
                           {
                               message = [NSString stringWithFormat:@"保存失败(%ld)",(long)error.code];
                           }
                           
                       } else {
                           message = @"成功保存到相册";
                       }
                       if(alert){
                           [MBTip showError:message toView:self.view];
                       }
                   }];
        };
        if([NSThread isMainThread]){
            callback();
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                callback();
            });
        }
    }
    else
    {
        if(alert)[MBTip showError:@"图片无效" toView:self.view];
    }
}

#pragma mark VcardForwardDelegate

- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    if(thread.length == 0){
        [UIView animateWithDuration:0.3
                         animations:^{
                             viewController.navigationController.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [viewController.navigationController.view removeFromSuperview];
                             [viewController.navigationController removeFromParentViewController];
                         }];
        return;
    }
    int64_t msgId = [viewController.objectForward longLongValue];
    
    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:msgId];
    if (chatEntity) {
        [[NIMMessageCenter sharedInstance] forwardRecordEntity:chatEntity toMsgBodyId:thread];
        completeBlock(VcardSelectedActionTypeForward,thread,nil);
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             viewController.navigationController.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [viewController.navigationController.view removeFromSuperview];
                             [viewController.navigationController removeFromParentViewController];
                         }];
    }
}


//TODO:设置scrollview的数据源
- (void)setPhotoDataSource:(NSArray*)photoObjects atIndex:(NSInteger)index showDelete:(BOOL)isShow
{
    [self showBrowser];
    self.scrolView.backgroundColor = [UIColor blackColor];
    [self.photoObjects addObjectsFromArray:photoObjects];
    if(photoObjects.count>1)
        [self setCurrentTitle:index];
    if(isShow)
    {
        self.btnDelete.hidden = NO;
        self.btnBack.hidden = NO;
    }
    
    [self.scrolView setScrollDataSource:self.photoObjects];
    [self.scrolView setContentOffset:CGPointMake(self.view.bounds.size.width*index, 0)];
    [self startLoading];
}

- (NSInteger)getCurrenteIndex
{
    NSInteger currentPage = (self.scrolView.contentOffset.x+self.scrolView.frame.size.width*0.5)/self.scrolView.frame.size.width;
    return currentPage+1;
}

- (void)startLoading
{
    NSInteger currentIndex = [self getCurrenteIndex];
    NSInteger totolCount = self.photoObjects.count;
    NIMPhotoView* photoView = (NIMPhotoView*)[self.scrolView viewWithTag:currentIndex];
    [photoView startLoadingImage];
    if(currentIndex>1)
    {
        NIMPhotoView* beforePhotoView = (NIMPhotoView*)[self.scrolView viewWithTag:currentIndex-1];
        [beforePhotoView startLoadingImage];
    }
    if(currentIndex<totolCount-2)
    {
        NIMPhotoView* lastPhotoView = (NIMPhotoView*)[self.scrolView viewWithTag:currentIndex+1];
        [lastPhotoView startLoadingImage];
    }
}

//TODO:删除照片
- (void)deletePic:(UIButton*)btn
{
    //删除crollview里面的子view
    NSArray* subviews = self.scrolView.subviews;
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if([obj isKindOfClass:[NIMPhotoView class]])
       {
           NIMPhotoView* p = (NIMPhotoView*)obj;
           [p removeFromSuperview];
       }
    }];
    
    if ([self.delegate respondsToSelector:@selector(deletePhotoAtIndex:)]) {
        [self.delegate deletePhotoAtIndex:[self getCurrenteIndex]-1];
    }
    
    [self.photoObjects removeObjectAtIndex:[self getCurrenteIndex]-1];//清除数据源
    if(self.photoObjects.count == 0)
    {
        [self hiddenSelf];
        return;
    }
    [self.scrolView setScrollDataSource:self.photoObjects];
    [self setCurrentTitle:[self getCurrenteIndex]];
    [self startLoading];
}

#pragma mark private method
- (void)setCurrentTitle:(NSInteger)index
{
    if(index == 0)
        index = 1;
    self.labTitle.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)self.photoObjects.count];
}


#pragma mark scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.photoObjects.count>1)
    {
        NSInteger currentPage = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
        [self setCurrentTitle:currentPage+1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startLoading];
}

#pragma mark setter
- (NIMPhotoScrollView*)scrolView
{
    if(!_scrolView)
    {
        _scrolView = [[NIMPhotoScrollView alloc] init];
        UIWindow* w = [UIApplication sharedApplication].keyWindow;
        _scrolView.frame = CGRectMake(0, 0, w.bounds.size.width, w.bounds.size.height);
        _scrolView.pagingEnabled = YES;
        _scrolView.delegate = self;
        _scrolView.VCDelegate = self;
        [self.view addSubview:_scrolView];
    }
    return _scrolView;
}

- (NSMutableArray*)photoObjects
{
    if(!_photoObjects)
    {
        _photoObjects = [[NSMutableArray alloc]init];
    }
    return _photoObjects;
}

- (UIView*)navagationView
{
    if(!_navagationView)
    {
        _navagationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        [self.view addSubview:_navagationView];
    }
    return _navagationView;
}

- (UIButton*)btnBack
{
    if(!_btnBack)
    {
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBack.frame = CGRectMake(0, 20, 60, 44);
        [_btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnBack setTitle:@"返回" forState:UIControlStateNormal];
        _btnBack.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_btnBack addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
        [self.navagationView addSubview:_btnBack];
    }
    return _btnBack;
}
- (UILabel*)labTitle
{
    if(!_labTitle)
    {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, self.view.bounds.size.width-120, 44)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont boldSystemFontOfSize:16];
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.hidden = YES;
        [self.navagationView addSubview:_labTitle];
    }
    return _labTitle;
}

- (UIButton*)btnDelete
{
    if(!_btnDelete)
    {
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDelete.frame = CGRectMake(self.view.bounds.size.width-60, 20, 60, 44);
        [_btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
        _btnDelete.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_btnDelete addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [self.navagationView addSubview:_btnDelete];
    }
    return _btnDelete;
}

@end
