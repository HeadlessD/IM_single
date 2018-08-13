//
//  NIMPhotoVC.h
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPhotoObject.h"
#import "NIMPhotoView.h"
#import "NIMPhotoScrollView.h"

@protocol NIMPhotoVCDelegate <NSObject>
@optional
- (void)deletePhontCallBack:(NSMutableArray*)photoObjects;
//删除第idx图片时回调
- (void)deletePhotoAtIndex:(NSInteger)deleleindex;
- (void)choosePhotoCallBack:(NSMutableDictionary*)selectPhotos;
- (void)choosePhotoNotBackCallBack:(NSMutableDictionary*)selectPhotos;
- (void)chooseGoodsImageDone:(NSMutableArray*)images index:(NSInteger)index andDeleteIndex:(NSInteger)deleteIndex;
@end

@interface NIMPhotoVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, assign) id<NIMPhotoVCDelegate>delegate;
@property (nonatomic, strong) UIView* navagationView;
@property (nonatomic, strong) NIMPhotoScrollView* scrolView;
@property (nonatomic, strong) UILabel* labTitle;
@property (nonatomic, strong) NSMutableArray* photoObjects;
- (void)setPhotoDataSource:(NSArray*)photoObjects atIndex:(NSInteger)index showDelete:(BOOL)isShow;
- (NSInteger)getCurrenteIndex;
- (void)startLoading;
- (void)hiddenAndDelay;
- (void)hiddenSelf;
@end
