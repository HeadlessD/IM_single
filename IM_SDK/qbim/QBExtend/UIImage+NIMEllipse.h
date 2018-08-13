//
//  UIImage+NIMEllipse.h
//  QianbaoIM
//
//  Created by liu nian on 6/7/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NIMEllipse)
//改变图片颜色
- (UIImage *)nim_imageWithColor:(UIColor *)color;
//TODO:compraseImage
- (UIImage *) nim_compraseImage: (UIImage *) largeImage;

+ (UIImage *)nim_imgWithVC:(UIViewController *)vc;

+ (UIImage *)nim_imageWithColor:(UIColor *)color andSize:(CGSize)size;

- (UIImage*)nim_uie_boxblurImageWithBlur:(CGFloat)blur;

+ (UIImage*)nim_transferImage:(UIImage*)oriImage orientation:(UIImageOrientation)orientation;


- (UIImage*) nim_stackBlur:(NSUInteger)inradius;

@end
