//
//  NIMPhotoView.h
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPhotoObject.h"

@protocol NIMPhotoViewDelegate  <NSObject>

@optional
- (void)shareToFriend:(id)imageUrl messageId:(int64_t)messageId;
- (void)saveImageToAlbum:(UIImage*)image;

@end
@interface NIMPhotoView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView* bigImageView;//展示在scrollview内部的大图imageview
@property (nonatomic, strong) UIScrollView* scrollView;//提供放大的scrollview
@property (nonatomic, strong) NIMPhotoObject* photoObject;
@property (nonatomic, assign) id<NIMPhotoViewDelegate>delegate;
- (void)setPhotoViewDataSource:(NIMPhotoObject*)photo;
- (void)startLoadingImage;
@end
