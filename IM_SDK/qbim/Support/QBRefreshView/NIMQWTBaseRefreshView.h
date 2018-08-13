//
//  QWTBaseRefreshView.h
//  Qianbao
//
//  Created by zhangtie on 13-8-28.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMRefreshView.h"
#import "NIMRefreshCell.h"
//#import "QBRefreshControl.h"
#import "NIMQBRefreshView.h"

#define kContentUpSet_64    64.0f

@class NIMQWTBaseRefreshView;
@class NIMBaseDataModel;
@protocol NIMQWTBaseRefreshViewDelegate <NSObject>

@optional
- (void)loadMore;

- (void)refreshData;

//新增
- (void)refreshData:(NIMQWTBaseRefreshView*)sender;

- (void)loadMore:(NIMQWTBaseRefreshView*)sender;

- (BOOL)isCanShowLoading:(NIMQWTBaseRefreshView*)sender;

- (BOOL)isCanHideLoading:(NIMQWTBaseRefreshView*)sender;

- (Class)getCellClass;
- (NSString*)getCellIndentify;
//tableview的selectedrow事件
- (void)didSelectedRowWithData:(NIMBaseDataModel*)data atIndexPath:(NSIndexPath*)indexPath;
- (void)headerClickAtIndex:(NSInteger)headIndex isHidden:(BOOL)isHide;

@end

@interface NIMQWTBaseRefreshView : UIView<NIMRefreshCellDelegate,NIMQBRefreshDelegate, SRRefreshDelegate, UIScrollViewDelegate, NIMQWTBaseRefreshViewDelegate>
{
    NIMRefreshView       *_headRefreshView;
    NIMRefreshCell         *_footRefreshView;
    NIMQBRefreshView       *_qbHeadRefreshView;
    UIScrollView        *_mainList;
    
    __weak id<NIMQWTBaseRefreshViewDelegate> _delegate;
}
@property(nonatomic, strong)NIMQBRefreshView       *qbHeadRefreshView;
@property(nonatomic, strong)NIMRefreshView       *headRefreshView;
@property(nonatomic, strong)UIRefreshControl    *sysHeadRefreshView;
@property(nonatomic, strong)NIMRefreshCell         *footRefreshView;
@property(nonatomic, strong)UIScrollView        *mainList;
@property(nonatomic, weak)id<NIMQWTBaseRefreshViewDelegate> delegate;


- (void)setUpInsetTop:(CGFloat)upInsetTop;  //适用于headRefreshView的适配

- (void)setContentInsetTop:(CGFloat)upInsetTop; //适用于footRefreshView适配

- (void)loadMore;
- (void)refreshData;

- (void)showHeader:(BOOL)bshow;
- (void)showFooter:(BOOL)bshow;
- (void)endFooterLoadState;
- (void)endHeaderRefreshState;

@end
