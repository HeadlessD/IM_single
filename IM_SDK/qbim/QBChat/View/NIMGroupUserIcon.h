//
//  NIMGroupUserIcon.h
//  QianbaoIM
//
//  Created by Yun on 14/9/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
  

@protocol NIMGroupUserIconDelegate <NSObject>
@optional
- (void)NIMGroupUserIconClick;

@end

@interface NIMGroupUserIcon : UIView

@property (nonatomic, assign) id<NIMGroupUserIconDelegate>delegate;

- (void)setViewDataSource:(NSArray*)users groupId:(int64_t)groupId;//设置群组图像
- (void)setViewDataSourceFromUrlString:(NSString*)usrStr;//设置图片url设置单个用户图像
- (void)setViewIconFromImage:(UIImage*)image;//直接通过图片设置image
- (void)getLocalPic:(NSInteger)groupCount groupId:(int64_t)groupId;

@end
