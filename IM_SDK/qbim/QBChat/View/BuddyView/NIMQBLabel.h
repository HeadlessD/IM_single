//
//  NIMQBLabel.h
//  QianbaoIM
//
//  Created by liu nian on 14-3-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "NIMIconMatch.h"

#define ICON_SIZE 18.0f
#define LINE_HEIGHT 20.0f
#define SPACE_WIDTH 0.0f

@interface NIMQBLabel : UILabel
{
    int line;
    float xIndex,yIndex;
    float maxWidth;
}
@property (nonatomic, strong) UIColor   *txtColor;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

- (void)setTextAndIcon:(NSString*)string;
- (void)setTextAndIcon:(NSString *)string  offX:(float)offx offY:(float)offy;

- (void)clear;

+ (NSDictionary *)getFaceMap;
+ (NSDictionary *)getBigFaceMap;
+ (NSString *)faceKeyForValue:(NSString *)value  map:(NSDictionary *) map;
+ (UIImage *)bigQBFaceWithTxt:(NSString *)faceKey;
@end



@interface NSString (HBLabel)

-(CGSize) hbSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
-(CGSize) hbSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size offX:(float)offx offY:(float)offy;

@end
