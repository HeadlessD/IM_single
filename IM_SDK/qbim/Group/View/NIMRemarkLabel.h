//
//  NIMRemarkLabel.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/8/23.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface NIMRemarkLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;


@end
