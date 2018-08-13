//
//  NIMInputPadHeader.h
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#ifndef QianbaoIM_NIMInputPadHeader_h
#define QianbaoIM_NIMInputPadHeader_h

typedef enum {
    kMediaPadHide           = 0,
    kInputPadModeDefault    = 1,  // 默认模式，文本框非编辑状态         //录音 输入框 表情 扩展
    kInputPadModeText       = 2,     // 文本框处编辑状态                 //录音 输入框 表情 扩展
    kInputPadModeAudio      = 3,    // 录音模式                        //键盘 录音框 表情 扩展
    kInputPadModeEmoji      = 4,      // 表情模式                        //录音 输入框 键盘 扩展
    kInputPadModeAdd        = 5,        //扩展模式                       //录音 输入框 表情 扩展
} NIMInputPadMode;

#endif
