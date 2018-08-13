//
//  NIMADview.h
//  QianbaoIM
//
//  Created by xuqing on 16/3/24.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NIMADviewDelegate <NSObject>

- (void)AdDeatil:(NSString*)url;//发红包选择联系人

@end


@interface NIMADview : UIView
@property(nonatomic,weak)id<NIMADviewDelegate>delegate;
@property(nonatomic,assign)BOOL firstTime;
@property(nonatomic,strong)NSMutableArray *ColorArray;
@property(nonatomic,strong)NSMutableArray *adArray;
@property(nonatomic,strong)UILabel *tipLable;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,assign)NSInteger adCount;
@property(nonatomic,strong)NSTimer *timer;

@end
