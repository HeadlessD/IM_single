//
//  UIImage+NIMEffects.h
//  QianbaoIM
//
//  Created by liyan on 9/23/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NIMEffects)

- (UIImage*)nim_blurredImage:(CGFloat)blurAmount;

+ (UIImage *)nim_animatedGIFNamed:(NSString *)name;

+ (UIImage *)nim_getVideoPreViewImage:(NSURL *)path;
@end
