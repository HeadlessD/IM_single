//
//  NIMPhotoView.m
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  展示图片

#import "NIMPhotoView.h"
#import "Masonry.h"
#import "ALAssetsLibrary+NIMCustomPhotoAlbum.h"
//#import "NIMLatestVcardViewController.h"
#import "UIImageView+WebCache.h"
#import "NIMActionSheet.h"
@interface NIMPhotoView()<UIActionSheetDelegate>
@property (nonatomic, assign) BOOL isDoublic;
@property (nonatomic, strong) MBProgressHUD* hub;

@end

@implementation NIMPhotoView


- (void)setPhotoViewDataSource:(NIMPhotoObject*)photo
{
    self.photoObject = photo;
    _isDoublic = NO;
    self.photoObject.loadFinish = NO;
    UIImage* pimage = nil;
    if(self.photoObject.originlImage)
    {
        pimage = self.photoObject.originlImage;
        self.bigImageView.image = pimage;
        [self adjustFrame];
        return;
    }
    else if(self.photoObject.placeHoldImage)
    {
        pimage = self.photoObject.placeHoldImage;
    }
    else if(self.photoObject.currentImageView.image)
    {
        pimage = self.photoObject.currentImageView.image;
    }
    self.bigImageView.image = pimage;
}
- (void)startLoadingImage
{
    if(self.photoObject.originlImage)
    {
        self.bigImageView.image = self.photoObject.originlImage;
        [self adjustFrame];
        return;
    }
    if(self.photoObject.loadFinish)
        return;
    if(self.photoObject.imageUrl)
    {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        [self.bigImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.photoObject.imageUrl] placeholderImage:self.bigImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > 0.0001) {
                //                                                                    self.hub.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.photoObject.originlImage = image;
            [self adjustFrame];
        }];
//        [self bringSubviewToFront:self.hub];
    }
    else
    {
        if(self.photoObject.placeHoldImage){
            self.bigImageView.image = self.photoObject.placeHoldImage;
            [self adjustFrame];
            return;
        }
        DBLog(@"无效数据");//这里可以加载一个默认的无效图片
        [MBTip showError:@"图片加载失败" toView:[UIApplication sharedApplication].keyWindow];
    }
}

- (UIScrollView*)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.zoomScale = 1;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView*)bigImageView
{
    if(!_bigImageView)
    {
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.frame = CGRectMake(0, (self.frame.size.height-self.frame.size.width)/2, self.frame.size.width, self.frame.size.width);
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer* signal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalClick:)];
        [self.scrollView addGestureRecognizer:signal];
        UITapGestureRecognizer* doubleclick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleclick.numberOfTapsRequired = 2;
        [self.scrollView addGestureRecognizer:doubleclick];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        
        [signal requireGestureRecognizerToFail:doubleclick];
        
        [self.scrollView addGestureRecognizer:longPress];
        [self.scrollView addSubview:_bigImageView];
    }
    return _bigImageView;
}


- (MBProgressHUD*)hub
{
    if(!_hub)
    {
        _hub = [[MBProgressHUD alloc]initWithView:self];
        _hub.mode = MBProgressHUDModeAnnularDeterminate;
        _hub.userInteractionEnabled = NO;
        [self addSubview:_hub];
    }
    return _hub;
}


- (void)signalClick:(UITapGestureRecognizer*)gesture
{
    _isDoublic = NO;
    [self performSelector:@selector(hiddenPhoto) withObject:nil afterDelay:0.2];
}

- (void)doubleClick:(UITapGestureRecognizer*)gesture
{
    _isDoublic = YES;
//    CGPoint touchPoint = [gesture locationInView:self.scrollView];
    
    
    CGPoint touchPoint = [gesture locationInView:_bigImageView];
    // Zoom
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale && self.scrollView.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.scrollView.maximumZoomScale + self.scrollView.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
    }
    

    /*
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        float a = (self.bounds.size.height - self.bigImageView.frame.size.height)/2;
        if (a<0) {
            a = 0;
        }
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.bigImageView setFrame:CGRectMake(0, 0, self.bigImageView.frame.size.width, self.bigImageView.frame.size.height)];
//                             self.bigImageView.center = self.scrollView.center;
                             [self adjustFrame];
                         }
                         completion:^(BOOL finished) {
                         }];
    } else {
         [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        float a = (self.bounds.size.height - self.bigImageView.frame.size.height)/2;

        if (a<0) {
            a = 0;
        }
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.bigImageView setFrame:CGRectMake(0, 0, self.bigImageView.frame.size.width, self.bigImageView.frame.size.height)];
                             self.bigImageView.center = self.scrollView.center;

                         }
                         completion:^(BOOL finished) {
                         }];

    }
     */
}

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.scrollView.minimumZoomScale;
    if (_bigImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _bigImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.scrollView.minimumZoomScale, zoomScale), self.scrollView.maximumZoomScale);
        }
    }
    return zoomScale;
}


- (void)longPressAction:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"保存到手机",@"转发给朋友"] AttachTitle:@""];
        [action ButtonIndex:^(NSInteger Buttonindex) {
            
            
            if(Buttonindex == 1)
            {
                if(_delegate && [_delegate respondsToSelector:@selector(saveImageToAlbum:)]){
                    [_delegate saveImageToAlbum:self.photoObject.originlImage];
                }
                //        [SSIMSpUtil saveImageToAlbum:self.photoObject.originlImage withAlert:YES];
            }
            if(Buttonindex == 2){
                DBLog(@"%@",self.photoObject.imageUrl);
                if(_delegate && [_delegate respondsToSelector:@selector(shareToFriend:messageId:)]){
                    
                    
                    
                    
                    
                    if(self.photoObject.imageUrl.length >0)
                    {
                        [_delegate shareToFriend:self.photoObject.imageUrl messageId:self.photoObject.messageId];
                    }
                    else
                    {
                        NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
                        SET_PARAM(self.photoObject.originlImage, @"thumbnail", imageDic);
                        SET_PARAM(self.photoObject.originlImage, @"original", imageDic);
                        
                        [_delegate shareToFriend:imageDic messageId:self.photoObject.messageId];
                    }
                    
                    
                }
            }
        }];
        
        [action show];
    }
    
}

- (void)hiddenPhoto
{
    if(!_isDoublic)
    {
        _isDoublic = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENQBPHOTOBROWSER" object:nil];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(saveImageToAlbum:)]){
            [_delegate saveImageToAlbum:self.photoObject.originlImage];
        }
//        [SSIMSpUtil saveImageToAlbum:self.photoObject.originlImage withAlert:YES];
    }
    if(buttonIndex == 1){
        DBLog(@"%@",self.photoObject.imageUrl);
        if(_delegate && [_delegate respondsToSelector:@selector(shareToFriend:messageId:)]){
            
            
            
            
            
            if(self.photoObject.imageUrl.length >0)
            {
                [_delegate shareToFriend:self.photoObject.imageUrl messageId:self.photoObject.messageId];
            }
            else
            {
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
                SET_PARAM(self.photoObject.originlImage, @"thumbnail", imageDic);
                SET_PARAM(self.photoObject.originlImage, @"original", imageDic);
                
                [_delegate shareToFriend:imageDic messageId:self.photoObject.messageId];
            }
        }
    }
}

- (id) traverseResponderChainForUIViewController:(UIView*)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        if(error.code == -3310)
        {
            [MBTip showError:@"请允许“钱宝”访问图片库" toView:nil];
        }
        else
        {
            [MBTip showError:@"保存失败" toView:nil];
        }
        
    } else {
        [MBTip showError:@"成功保存到相册" toView:nil];
    }
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _bigImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _bigImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_bigImageView.frame, frameToCenter)){
        _bigImageView.frame = frameToCenter;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

//    self.bigImageView.center = self.scrollView.center;
//    float a = (self.bounds.size.height - self.bigImageView.frame.size.height)/2;
//    if (a<0) {
//        a = 0;
//    }
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [self.bigImageView setFrame:CGRectMake(0, a, self.bigImageView.frame.size.width, self.bigImageView.frame.size.height)];
//                     }
//                     completion:^(BOOL finished) {
//                     }];
}

#pragma mark 调整frame
- (void)adjustFrame
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    if (_bigImageView.image == nil) return;
    self.photoObject.loadFinish = YES;
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _bigImageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 5.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.scrollView.maximumZoomScale = maxScale;
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
//    CGRect imageFrame = CGRectZero;
//    if (imageWidth>boundsWidth) {
//        imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
//    }else{
//        imageFrame = CGRectMake(0, 0, imageWidth, imageHeight);
//    }
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);

    
    // 内容尺寸
    self.scrollView.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // x值
//    if (imageFrame.size.width < boundsWidth) {
//        imageFrame.origin.x = floorf((boundsWidth - imageFrame.size.width) / 2.0);
//    } else {
//        imageFrame.origin.x = 0;
//    }
//    // y值
//    if (imageFrame.size.height < boundsHeight) {
//        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
//    } else {
//        imageFrame.origin.y = 0;
//    }
    if (imageFrame.size.height > boundsHeight) {
        imageFrame.origin.x = 0;
        imageFrame.origin.y = 0;
        _bigImageView.frame = imageFrame;
    }else{
        _bigImageView.frame = imageFrame;
        _bigImageView.center = self.scrollView.center;
    }
    
}


@end
