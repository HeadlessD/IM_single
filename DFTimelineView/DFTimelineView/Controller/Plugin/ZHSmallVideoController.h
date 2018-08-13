//
//  ZHSmallVideoController.h
//  ZHSmallVideoDemo
//
//  Created by Cloud on 2018/1/12.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHSmallVideoControllerDelegate <NSObject>
- (void)zh_delegateVideoInLocationUrl:(NSURL *)url;
@end

@interface ZHSmallVideoController : UIViewController
@property (nonatomic , copy) void (^finishBlock)(NSURL *url,int64_t msgid);
@property (nonatomic , assign) E_MSG_CHAT_TYPE chatType;

- (instancetype)initWithDelegate:(id<ZHSmallVideoControllerDelegate>)zh_delegate;
@end
