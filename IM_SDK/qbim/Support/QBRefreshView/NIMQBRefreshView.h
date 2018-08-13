//
//  QBRefreshView.h
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-13.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NIMQBRefreshDelegate;
@interface NIMQBRefreshView : UIView
{

}
@property (nonatomic, assign)UIScrollView           *scrollView;
@property (nonatomic, assign)id<NIMQBRefreshDelegate>   delegate;

//- (void)setOffHeigth:(int)OffHeigth;
- (void)scrollViewWillBeginDragging;
- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
- (void)endRefresh;


@end

@protocol NIMQBRefreshDelegate <NSObject>

@optional
//start refresh.
- (void)QBRefreshStartRefresh:(NIMQBRefreshView*)refreshView;

@end
