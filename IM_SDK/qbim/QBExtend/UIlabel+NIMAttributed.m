//
//  UIlabel+NIMAttributed.m
//  QianbaoIM
//
//  Created by Yun on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "UIlabel+NIMAttributed.h"

@implementation UILabel (UIlabel_Attributed)

- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    while ((range = [str rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    return results;
}

- (void)nim_setOriginalText:(NSString*)oriText
           originaColor:(UIColor*)oriColor
           originalFont:(UIFont*)oriFont
          attributedStr:(NSString*)attributStr
        attributedColor:(UIColor*)attributColor
         attributerFont:(UIFont*)attributFont
{
    if (IsStrEmpty(oriText))
        return;
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:oriText];
    NSRange lastRange       = NSMakeRange(0, oriText.length);
    
    [mutaString addAttribute:NSForegroundColorAttributeName
                       value:oriColor
                       range:lastRange];
    
    [mutaString addAttribute:NSFontAttributeName
                       value:oriFont
                       range:lastRange];
    
    if(attributStr.length > 0)
    {
        NSArray *ranges = [self rangesOfString:attributStr inString:oriText];
        [ranges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSValue *value = obj;
            NSRange range = [value rangeValue];
            
            [mutaString addAttribute:NSFontAttributeName
                               value:attributFont
                               range:range];
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:attributColor
                               range:range];
            
        }];
    }
    
    self.attributedText = mutaString;
}

@end
