//
//  NIMZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NIMZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *placeHoderImage; //默认图片
@property (nonatomic, retain) UIImage *thumbImage;   //小图片
@property (nonatomic, retain) UIImage *originalImage;//原始图片
@property (nonatomic, retain) MBProgressHUD *hub;//原始图片

- (void)zoomWihtMinScale;

@end
