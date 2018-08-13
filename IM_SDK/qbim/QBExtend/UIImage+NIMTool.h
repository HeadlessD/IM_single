//
//  UIImage+CCTool.h
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NIMTool)

- (UIImage *)nim_croppedImage:(CGRect)bounds;

- (UIImage *)nim_resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)nim_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)nim_resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)nim_transformForOrientation:(CGSize)newSize;

- (UIImage *)nim_fixOrientation;

- (UIImage *)nim_rotatedByDegrees:(CGFloat)degrees;

@end
