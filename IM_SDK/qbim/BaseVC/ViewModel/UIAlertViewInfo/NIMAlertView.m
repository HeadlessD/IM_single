//
//  NIMAlertView.m
//  QianbaoIM
//
//  Created by liyan on 5/1/15.
//  Copyright (c) 2015 qianbao.com. All rights reserved.
//

#import "NIMAlertView.h"

@implementation NIMAlertView

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    BOOL ok = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDismissAlertView:clickedButtonAtIndex:)]) {
        ok = [self.delegate shouldDismissAlertView:self clickedButtonAtIndex:buttonIndex];
    }
    
    if (ok) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}
@end
