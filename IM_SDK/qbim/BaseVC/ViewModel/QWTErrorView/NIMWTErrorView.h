//
//  NIMWTErrorView.h
//  TicketsProject
//
//  Created by zhangtie on 14-7-1.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMConstHeader.h"
@class NIMWTErrorView;
@protocol NIMWTErrorViewDelegate <NSObject>

@optional
- (void)doErrHandle:(NIMWTErrorView*)sender;

@end

@interface NIMWTErrorView : UIView

_PROPERTY_NONATOMIC_RETAIN(UIButton,       btnDoErr);
_PROPERTY_NONATOMIC_ASSIGN(BOOL,           userIMG);
_PROPERTY_NONATOMIC_ASSIGN(id<NIMWTErrorViewDelegate>, delegate);

@end
