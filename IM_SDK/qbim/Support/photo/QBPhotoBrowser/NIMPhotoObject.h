//
//  NIMPhotoObject.h
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMPhotoObject : NSObject
@property (nonatomic, assign) UIImageView* currentImageView;//原始图片view
@property (nonatomic, strong) UIImage* originlImage;//大图图片
@property (nonatomic, strong) UIImage* placeHoldImage;//默认图片，如果没有指定，从原始图片读取
@property (nonatomic, copy) NSString* imageUrl;//大图URL地址
@property (nonatomic, copy) NSString* picId;//大图URL地址
@property (nonatomic, assign) BOOL loadFinish;
@property (nonatomic, assign) int64_t messageId;

@end
