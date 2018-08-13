//
//  NIMPhotosWallPreviewViewController.m
//  QianbaoIM
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//


#import "NIMPhotosWallPreviewViewController.h"
//#import "NIMPhotosWallPreviewViewController.h"
#import "NIMPhotosWallEditViewController.h"
#import "NIMZoomScrollView.h"
#import "NIMSelfViewController.h"
#import "NIMPhotosWallEditViewController.h"
#import "NIMLatestVcardViewController.h"
#import "ALAssetsLibrary+NIMCustomPhotoAlbum.h"
//#import "MessageNIMOperationBox.h"
#import "NIMActionSheet.h"

#import "NIMSelfViewController.h"

@interface NIMPhotosWallPreviewViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView     *scroll;

@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) UIButton      *backBtn;

@end

@implementation NIMPhotosWallPreviewViewController
{
    float viewW;
    float viewH;
    
    int totlePage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    totlePage = 0;
    UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:backGroundView];
    self.view.backgroundColor = [UIColor clearColor];
    viewW = self.view.frame.size.width;
    viewH = [UIScreen mainScreen].bounds.size.height;
    
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
    }];
    
    
    self.pageControl = [[UIPageControl alloc]init];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-48-10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(100));
        make.height.equalTo(@(10));
    }];
    if (self.hidePageCt == TRUE) {
        self.pageControl.hidden = YES;

    }
    
     self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.backBtn];
    UITapGestureRecognizer *headBgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headBgTap:)];
    [self.backBtn  setImage:IMGGET(@"btn_pack-up") forState:UIControlStateNormal] ;
    [self.backBtn addGestureRecognizer:headBgTap];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageControl.mas_bottom).offset(-10);
        make.centerX.equalTo(self.pageControl.mas_centerX);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    [self reloadData];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.rightBtType == _ScanNoneType) {
        [self qb_showRightButton:nil];
    }else{
        [self qb_showRightButton:self.rightBtText andBtnImg:nil tyleTheme:THEME_COLOR_TRANSPARENT_WHITE];
    }
    [self setNavigationBarTransparent];
    if (self.showBack == NO ) {
        [self qb_showBackButton:NO];
        self.backBtn.hidden = NO;
    }else{
        [self qb_showBackButton:YES];
        self.backBtn.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNavigationBarTransparent];
    
}

- (void)setNavigationBarTransparent
{
    UIImage * img = nil;
    img = IMGGET(@"bg_qb_topbar_20");
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - scrolldelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    if (self.imagesUrls.count && page <self.imagesUrls.count) {
        [self startLoadingOriginalImageIndex:page];
        
    }
    [self refreshTitleWithIndex:0];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self refreshTitleWithIndex:0];
}






#pragma mark - 点击右键
//TODO:右键
- (void)qb_rightButtonAction
{
    
    if (self.rightBtType == _ScanNoneType) {
        return;
    }else if (self.rightBtType == _ScanDeleteType) {
        [self deleteImage];
    }else if (self.rightBtType == _ScanEditType) {
        [self editImage];
    }
  
    
}

- (void)deleteImage{
    //删除
    if (totlePage <= 0) {
        return;
    }
    
    NIMRIButtonItem * cancelItem = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    NIMRIButtonItem * okItem      = [NIMRIButtonItem itemWithLabel:@"确定" action:^{
        //数据删除
        int page = [self getCurrentPage];
        if (self.imagesUrls.count && page <self.imagesUrls.count) {
            [self.imagesUrls removeObjectAtIndex:page];
            [self.thumbImageUrls removeObjectAtIndex:page];
            
        }else{
            [self.localImages removeObjectAtIndex:page-self.imagesUrls.count];
        }
   
        //更新界面
        [[self.scroll viewWithTag:100 +page] removeFromSuperview];
        totlePage = (int)self.imagesUrls.count + (int)self.localImages.count;
        if (totlePage == 0) {
            [self qb_back];
        }
        [self.scroll setContentSize:CGSizeMake((totlePage)*viewW, self.scroll.frame.size.height)];
        for (int i = 0 ; i< self.scroll.subviews.count ;i++) {
            NIMZoomScrollView * _zoomScrollView = [self.scroll.subviews objectAtIndex:i];
            _zoomScrollView.tag = 100 + i;
            CGRect frame = CGRectMake(0, 0, viewW, viewH);
            frame.origin.x = i*viewW;
            frame.origin.y = 0;
            _zoomScrollView.frame = frame;
        }
        [self refreshTitleWithIndex:nil];
        
        
    }];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithNimTitle:nil message:@"确定要删除当前图片么？" cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
    
    [alert show];
}

- (void)editImage{
    //编辑
    NIMPhotosWallEditViewController *ct = [[NIMPhotosWallEditViewController alloc]init];
    ct.imageUrls = self.imagesUrls;
    [self.navigationController pushViewController:ct animated:YES];
}

#pragma mark - 点击返回

- (void)headBgTap:(UITapGestureRecognizer *)tap{
    //返回时候缩放为原图
    int page = [self getCurrentPage];
    NIMZoomScrollView * _zoomScrollView = (NIMZoomScrollView *)[self.scroll viewWithTag:(100 + page)];
    [_zoomScrollView zoomWihtMinScale];
    
    
    [self performSelector:@selector(qb_backWithoutAnimated) withObject:nil afterDelay:0.2];
}

-(void)qb_backWithoutAnimated{
    if([self.delegate class] == [NIMSelfViewController class]){
        // 设置前一个页面和当前页面图片一致
        if (_delegate && [_delegate respondsToSelector:@selector(resetBgImageWithIndex:imagesUrls:)])
        {
            [self.delegate resetBgImageWithIndex:[self getCurrentPage] imagesUrls:self.imagesUrls];
        }
    }
    [super qb_backWithoutAnimated];
}
- (void)popCt{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)qb_back{
    if([self.delegate class] == [NIMPhotosWallEditViewController class]){
        // 设置前一个页面和当前页面图片一致
        if (_delegate && [_delegate respondsToSelector:@selector(resetLayoutWithUrls:images:)])
        {
            [self.delegate resetLayoutWithUrls:self.imagesUrls images:self.localImages];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 长按
- (void)longPressAction:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"保存到手机",@"转发给朋友"] AttachTitle:@""];
        [action ButtonIndex:^(NSInteger Buttonindex) {
            
            
            int page = [self getCurrentPage];
            NIMZoomScrollView * _zoomScrollView = (NIMZoomScrollView *)[self.scroll viewWithTag:(100 +page)];
            UIImage *image = _zoomScrollView.imageView.image;
            
            if(Buttonindex == 0)
            {
                [self saveImageToAlbum:image];
            }
            
            if(Buttonindex == 1){
                if (self.imagesUrls.count && page <self.imagesUrls.count) {
                    [self shareToFriend:[self.imagesUrls objectAtIndex:page]];
                }else
                {
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
                    SET_PARAM(image, @"thumbnail", imageDic);
                    SET_PARAM(image, @"original", imageDic);
                    [self shareToFriend:imageDic];
                }
            }
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int page = [self getCurrentPage];
    NIMZoomScrollView * _zoomScrollView = (NIMZoomScrollView *)[self.scroll viewWithTag:(100 +page)];
    UIImage *image = _zoomScrollView.imageView.image;
    //

    if(buttonIndex == 0)
    {
        [self saveImageToAlbum:image];
    }
    
    if(buttonIndex == 1){
        if (self.imagesUrls.count && page <self.imagesUrls.count) {
            [self shareToFriend:[self.imagesUrls objectAtIndex:page]];
        }else
        {
            NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
            SET_PARAM(image, @"thumbnail", imageDic);
            SET_PARAM(image, @"original", imageDic);
            [self shareToFriend:imageDic];
        }
    }
}


- (void)shareToFriend:(id)imageUrl{
    DBLog(@"%@",imageUrl);
    
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.delegate = self;
        latestVVC.objectForward = imageUrl;
    }
    [self presentViewController:latestVcardNavigation animated:YES completion:^{
        
    }];

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
                           if(error.code == -3310)
                           {
                               message = @"请允许“钱宝”访问图片库";
                           }
                           else
                           {
                               message = @"保存失败";
                           }
                           
                       } else {
                           message = @"成功保存到相册";
                       }
                       if(alert){
                          // [MBProgressHUD showError:message toView:self.view];
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
        //if(alert)[MBProgressHUD showError:@"图片无效" toView:self.view];
    }
}


#pragma mark VcardForwardDelegate
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    if(thread.length == 0){
        [viewController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}


#pragma mark - data and reload
- (void)reloadData{
    [[self.scroll subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    totlePage = (int)self.imagesUrls.count + (int)self.localImages.count;
    [self.scroll setContentSize:CGSizeMake(totlePage*viewW, self.scroll.frame.size.height)];
    //    // 加载网络图片
    for (int i = 0; i < self.imagesUrls.count; i++) {
        NIMZoomScrollView * _zoomScrollView = [[NIMZoomScrollView alloc]init];
        _zoomScrollView.tag = 100 + i;
        CGRect frame = CGRectMake(i*viewW, 0, viewW, viewH);
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        _zoomScrollView.placeHoderImage = IMGGET(@"bg_dialog_pictures");
        if (self.placeHoderImage) {
            _zoomScrollView.placeHoderImage = self.placeHoderImage;

        }
        
        if (!_zoomScrollView.imageView.image) {
            _zoomScrollView.imageView.image =  _zoomScrollView.placeHoderImage;
        }
        
//        UILongPressGestureRecognizer *longPressAction = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//        [_zoomScrollView.imageView addGestureRecognizer:longPressAction];
        
        //加载小图
        NSString *thumbImageStr = [self.thumbImageUrls objectAtIndex:i];
        NSURL *imageUrl = [NSURL URLWithString:thumbImageStr];
        [self startLoadingThumbImage:imageUrl imageView:_zoomScrollView];
        [self.scroll addSubview:_zoomScrollView];
    }
    
    int localImageBeginIndex = (int)self.imagesUrls.count;
    for (int i = 0; i < self.localImages.count; i++) {
        NIMZoomScrollView * _zoomScrollView = [[NIMZoomScrollView alloc]init];
        _zoomScrollView.tag = 100 + localImageBeginIndex + i;
        CGRect frame = CGRectMake(0, 0, viewW, viewH);
        frame.origin.x = (localImageBeginIndex + i)*viewW;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        _zoomScrollView.placeHoderImage = IMGGET(@"bg_dialog_pictures");
        if (!_zoomScrollView.imageView.image) {
            _zoomScrollView.imageView.image =  _zoomScrollView.placeHoderImage;
        }
//        UILongPressGestureRecognizer *longPressAction = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//        [_zoomScrollView.imageView addGestureRecognizer:longPressAction];
        _zoomScrollView.imageView.image = [self.localImages objectAtIndex:i];
        
        [self.scroll addSubview:_zoomScrollView];
    }
    
    [self.scroll setContentOffset:CGPointMake(self.selectedIndex * viewW, 0)];
    //加载第一张大图
    if (self.imagesUrls.count && self.selectedIndex <self.imagesUrls.count) {
        [self startLoadingOriginalImageIndex:(int)self.selectedIndex];
    }
    [self performSelector:@selector(refreshTitleWithIndex:) withObject:@(self.selectedIndex) afterDelay:0.2];
    
    
}

- (void)startLoadingThumbImage:(NSURL *)url imageView:(NIMZoomScrollView *)_zoomScrollView{
    if (!_zoomScrollView.thumbImage) {
        
        
        [ _zoomScrollView.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:_zoomScrollView.imageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > 0.0001) {
                _zoomScrollView.hub.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _zoomScrollView.imageView.image = image;
                _zoomScrollView.thumbImage = image;
            }
        }];
    }
}
- (void)startLoadingOriginalImageIndex:(int)index{
    
    NSURL *imageUrl = [NSURL URLWithString:[self.imagesUrls objectAtIndex:index]];
    NIMZoomScrollView * _zoomScrollView = (NIMZoomScrollView *)[self.scroll viewWithTag:(100 +index)];
    [self startLoadingOriginalImage:imageUrl imageView:_zoomScrollView];
    
    if(index>=1)
    {
        NIMZoomScrollView* beforePhotoView = (NIMZoomScrollView*)[self.scroll viewWithTag:100 +index-1];
        NSURL *imageUrl = [NSURL URLWithString:[self.imagesUrls objectAtIndex:index-1]];
        [self startLoadingOriginalImage:imageUrl imageView:beforePhotoView];
    }
    if(index<self.imagesUrls.count-1)
    {
        NIMZoomScrollView* afterPhotoView = (NIMZoomScrollView*)[self.scroll viewWithTag:100 +index+1];
        NSURL *imageUrl = [NSURL URLWithString:[self.imagesUrls objectAtIndex:index+1]];
        [self startLoadingOriginalImage:imageUrl imageView:afterPhotoView];
    }
}

- (void)startLoadingOriginalImage:(NSURL *)url imageView:(NIMZoomScrollView *)_zoomScrollView{
    if (!_zoomScrollView.originalImage) {
        [_zoomScrollView.hub show:NO];
        
        
        [ _zoomScrollView.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:_zoomScrollView.imageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > 0.0001) {
                _zoomScrollView.hub.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _zoomScrollView.imageView.image = image;
                _zoomScrollView.originalImage = image;
            }
            [_zoomScrollView.hub hide:YES];
        }];
        [_zoomScrollView bringSubviewToFront:_zoomScrollView.hub];
    }
    
}

- (int )getCurrentPage{
    return self.scroll.contentOffset.x / self.scroll.frame.size.width;
}

- (void)refreshTitleWithIndex:(id)index{
    int currentPage = 0 ;
    if (index) {
        NSNumber *indexInt = (NSNumber*)index;
        currentPage = indexInt.intValue;
    }else{
        currentPage = [self getCurrentPage];
    }
    if (self.titleText && ![self.titleText isEqualToString:@""]) {
        [self qb_setTitleText:self.titleText];
    }else{
        NSString *titleStr = [NSString stringWithFormat:@"%ld / %lu",(long)(currentPage +1) ,(unsigned long)(totlePage)];
        [self qb_setTitleText:titleStr];
    }
    self.pageControl.numberOfPages = totlePage; // 一共显示多少个圆点（多少页）
    self.pageControl.currentPage = currentPage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
