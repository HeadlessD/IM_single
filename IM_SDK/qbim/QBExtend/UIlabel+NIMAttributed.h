//
//  UIlabel+NIMAttributed.h
//  QianbaoIM
//
//  Created by Yun on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UIlabel_Attributed)

/**
 @descrtion:富文本label显示
 @parm: oriText label显示的文字，oriColor默认字体颜色，oriFont默认字体，attributStr需要高亮的字，attributColor高亮的字体颜色，attributFont高亮字体
 */
- (void)nim_setOriginalText:(NSString*)oriText
           originaColor:(UIColor*)oriColor
           originalFont:(UIFont*)oriFont
          attributedStr:(NSString*)attributStr
        attributedColor:(UIColor*)attributColor
         attributerFont:(UIFont*)attributFont;

@end
