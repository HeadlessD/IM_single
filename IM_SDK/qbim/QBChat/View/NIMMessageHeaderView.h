//
//  NIMMessageHeaderView.h
//  QianbaoIM
//
//  Created by Yun on 14/8/13.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _TAG_EVENT_QIANBAO_BUTTON
{
    TAG_EVENT_QIANBAO_BUTTON_SIGN       = 1,
    TAG_EVENT_QIANBAO_BUTTON_RECOMMOD   = 2,
    TAG_EVENT_QIANBAO_BUTTON_RECHARGE   = 3,
}TAG_EVENT_QIANBAO_BUTTON;

@protocol NIMMessageHeaderViewDelegate <NSObject>

@optional
- (void)MHheaderClick:(UIButton*)sender;

@end

@interface NIMMessageHeaderView : UIView
@property (nonatomic, weak) id<NIMMessageHeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL webLogin;
- (void)headerButtonClick:(id)sender;
- (void)webLoginOut:(id)sender;
- (void)layoutView;
- (void)addSignMark:(BOOL)mark;
@end
