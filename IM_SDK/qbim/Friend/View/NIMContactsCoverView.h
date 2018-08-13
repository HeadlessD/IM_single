//
//  NIMContactsCoverView.h
//  QianbaoIM
//
//  Created by Yun on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMContactsCoverView;
@protocol NIMContactsCoverViewDelegate <NSObject>

@optional
- (void)hiddenContactsView;
- (void)addFriend;
- (void)addGroupChat;

@end

@interface NIMContactsCoverView : UIView
@property (nonatomic, weak) id<NIMContactsCoverViewDelegate>delegate;


@end
