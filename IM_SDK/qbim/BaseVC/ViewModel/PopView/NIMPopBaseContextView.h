//
//  NIMPopBaseContextView.h
//  QianbaoIM
//
//  Created by liyan on 9/23/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NIMEditInfoCellModel.h"

@class NIMPopView;
@protocol NIMPopBaseContextViewDelegate<NSObject>

@optional
- (void)didSelectUpdateModel:(id)model;
- (void)didSelectUpdateModel:(id)model type:(id)type;

- (void)didCloseContextView;

//将分享到qq，只有分享到QQ时触发，因为分享到qq,有返回，和留在QQ界面。
- (void)willShareToQQ:(id)model;
- (void)shareCompletedCallback:(id)model withState:(NSInteger)state;

@end

@interface NIMPopBaseContextView : UIView

- (id)initWithHeight:(CGFloat)height;

@property (nonatomic, weak)NIMPopView *popView;

@property (nonatomic, weak)id<NIMPopBaseContextViewDelegate> delegate;
@property(nonatomic, strong)id model;
- (void)updateUIWithModel:(id)data;
- (void)show;

@end

@interface NIMPopBaseContextView(deprecated)
@end
