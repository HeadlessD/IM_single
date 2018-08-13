//
//  NIMRightTipView.h
//  QianbaoIM
//
//  Created by liyan on 10/19/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RightViewType){
    
    COLLETCTION_TYPE,       //收藏
    DIANZANG_TYPE           //点赞
};


@interface NIMRightTipView : UIView
@property (nonatomic, assign) RightViewType rightType;

- (void)setMessage:(NSString *)message;
- (void)setNoIconMessage:(NSString *)message;

@end
