//
//  NIMPublicBottomView.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/7/11.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NIMPublicBottomViewdelegate <NSObject>
@optional
-(void)showKeyBoardView;
-(void)enterShopBtnPressed;
@end
@interface NIMPublicBottomView : UIView
@property(nonatomic,assign) id<NIMPublicBottomViewdelegate>delegate;
@end
