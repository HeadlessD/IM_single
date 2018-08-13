//
//  NIMMyLable.h
//  UIlable字体居上
//
//  Created by lili on 16/2/1.
//  Copyright © 2016年 王可伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface NIMMyLable : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment;
@end
