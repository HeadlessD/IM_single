//
//  NIMBadgeView.m
//  QianbaoIM
//
//  Created by liunian on 14/9/17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMBadgeView.h"

@implementation NIMBadgeView


@synthesize width=__width, badgeString=__badgeString, parent=__parent, badgeColor=__badgeColor, badgeColorHighlighted=__badgeColorHighlighted, showShadow=__showShadow, radius=__radius;

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    CGFloat fontsize = 11;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paraStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attrs = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont boldSystemFontOfSize:fontsize]};
    CGSize numberSize = [self.badgeString sizeWithAttributes:attrs];
    CGRect bounds = CGRectMake(0 , 0, numberSize.width + 12 , 28);
    CGFloat radius = (__radius)?__radius:4.0;
    
    UIColor *colour;
    
    if((__parent.selectionStyle != UITableViewCellSelectionStyleNone) && (__parent.highlighted || __parent.selected))
    {
        if (__badgeColorHighlighted)
        {
            colour = __badgeColorHighlighted;
        } else {
            colour = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.000f];
        }
    } else {
        if (__badgeColor)
        {
            colour = __badgeColor;
        } else {
            colour = [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
        }
    }
    
    // Bounds for thet text label
    bounds.origin.x = (bounds.size.width - numberSize.width) / 2.0f + 0.5f;
    bounds.origin.y += 2;
    
    CALayer *__badge = [CALayer layer];
    [__badge setFrame:rect];
    
    CGSize imageSize = __badge.frame.size;
    
    // Render the image @x2 for retina people
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00)
    {
        imageSize = CGSizeMake(__badge.frame.size.width * 2, __badge.frame.size.height * 2);
        [__badge setFrame:CGRectMake(__badge.frame.origin.x,
                                     __badge.frame.origin.y,
                                     __badge.frame.size.width*2,
                                     __badge.frame.size.height*2)];
        fontsize = (fontsize * 2);
        bounds.origin.x = ((bounds.size.width * 2) - (numberSize.width * 2)) / 2.0f + 1;
        bounds.origin.y += 3;
        bounds.size.width = bounds.size.width * 2;
        radius = radius * 2;
    }
    
    [__badge setBackgroundColor:[colour CGColor]];
    [__badge setCornerRadius:radius];
    
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    [__badge renderInContext:context];
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    [__badgeString drawInRect:bounds withAttributes:attributes];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [outputImage drawInRect:rect];
    
    if((__parent.selectionStyle != UITableViewCellSelectionStyleNone) && (__parent.highlighted || __parent.selected) && __showShadow)
    {
        [[self layer] setCornerRadius:radius];
        [[self layer] setShadowOffset:CGSizeMake(0, 1)];
        [[self layer] setShadowRadius:1.0];
        [[self layer] setShadowOpacity:0.8];
    } else {
        [[self layer] setCornerRadius:radius];
        [[self layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self layer] setShadowRadius:0];
        [[self layer] setShadowOpacity:0];
    }
}

- (void) dealloc
{
    __parent = nil;
    __badgeString = nil;
    __badgeColor = nil;
}


@end
