//
//  NIMChatCountView.h
//  qbnimclient
//
//  Created by 秦雨 on 17/12/6.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NIMChatCountViewDelegate <NSObject>

-(void)clickAtChatCountView;

@end

@interface NIMChatCountView : UIView
@property(nonatomic,weak)id<NIMChatCountViewDelegate>delegate;
@property(nonatomic,assign)NSInteger UCount;

-(instancetype)initBottomViewWithFrame:(CGRect)frame;

@end
