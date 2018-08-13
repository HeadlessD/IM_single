//
//  NIMInputPadDelegate.h
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIMBaseInputPad;
@protocol NIMInputPadDelegate <NSObject>

@optional
// 输入面板尺寸、坐标发生了变化
- (void)inputPadFrameChanged:(NIMBaseInputPad *)inputPad textViewMargin:(int)margin;

// 输入面板模式发生了变化
- (void)inputPadModeChanged:(NIMBaseInputPad *)inputPad;

// 发送文本
- (void)inputPadSendTextRequested:(NIMBaseInputPad *)inputPad;

// 即将开始录音
- (void)inputPadWillRecord:(NIMBaseInputPad *)inputPad;

// 结束录音
- (void)inputPadDidRecord:(NIMBaseInputPad *)inputPad audioPath:(NSString *)audioPath;

// 取消录音
- (void)inputPadCancelRecord:(NIMBaseInputPad *)inputPad;


// 通知输入状态
- (void)inputPadComposing:(BOOL)composing;

- (void)changeTableHeight;

- (BOOL)richPadIsShown;

- (void)hideChatMediaPad;

@end
