//
//  NIMAlertView.h
//  QianbaoIM
//
//  Created by liyan on 5/1/15.
//  Copyright (c) 2015 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMAlertView;

@protocol NIMAlertViewDelete<UIAlertViewDelegate>
@optional
- (BOOL)shouldDismissAlertView:(NIMAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface NIMAlertView : UIAlertView
@property (nonatomic, strong)id info;
@end
