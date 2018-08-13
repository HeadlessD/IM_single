//
//  QWTBaseRefreshView.m
//  Qianbao
//
//  Created by zhangtie on 13-8-28.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import "NIMQWTBaseRefreshView.h"

#define kPushRefreshBodyColor                   _RGB_A(60, 60, 60, 1.0) //[UIColor colorWithRed:212.0/255.0 green:177.0/255.0 blue:138.0/255.0 alpha:1.0f]
#define kPushRefreshSkinColor                   [UIColor clearColor]

@interface NIMQWTBaseRefreshView ()

_PROPERTY_NONATOMIC_ASSIGN(BOOL, qbm_systemRefresh);        //default is YES
_PROPERTY_NONATOMIC_WEAK(UIView, qbm_currentHeadRefreshView);
_PROPERTY_NONATOMIC_RETAIN(UIView, qbm_refreshView);

@end

@implementation NIMQWTBaseRefreshView

@synthesize mainList = _mainList;

- (void)dealloc
{
    if (_mainList) {
        //[self.mainList removeHeader];
    }
//    [self.mainList removeObserver:self forKeyPath:@"contentInset"];
    [self.qbm_currentHeadRefreshView.layer removeAllAnimations];
    [self.qbm_currentHeadRefreshView removeFromSuperview];
    RELEASE_SAFELY(_headRefreshView);
    RELEASE_SAFELY(_sysHeadRefreshView);
    
    _footRefreshView.delegate = nil;
    [_footRefreshView detach];
    RELEASE_SAFELY(_footRefreshView);
    RELEASE_SAFELY(_mainList);
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self qbf_setInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self qbf_setInit];
}

- (void)qbf_setInit
{
    
    self.qbm_systemRefresh = YES;
    
    if(_qbm_currentHeadRefreshView)
    {
        [_qbm_currentHeadRefreshView removeFromSuperview];
        _qbm_currentHeadRefreshView = nil;
    }
    

    self.mainList.delegate = self;
    
//    [self.mainList addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:NULL];
//    [self showHeader:YES];
//    [self showHeader:NO];
//    [self.mainList addSubview:self.qbm_currentHeadRefreshView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentInset"])
    {
        DBLog(@"contentInset:====%@====", change);
    }
}

- (void)loadMore
{
    SEL callBack = @selector(loadMore);
    SEL callBackSender = @selector(loadMore:);
    if(_delegate && [_delegate respondsToSelector:callBack])
    {
        [_delegate loadMore];
//        [_delegate performSelector:callBack];
    }
    
    else if (_delegate && [_delegate respondsToSelector:callBackSender])
    {
        [_delegate loadMore:self];
//        [_delegate performSelector:callBackSender withObject:self];
    }
    
    else
    {
        return;
    }
}

- (void)refreshData
{
    SEL callBack = @selector(refreshData);
    SEL callBackSender = @selector(refreshData:);
    if(_delegate && [_delegate respondsToSelector:callBack])
    {
//        [_delegate performSelector:callBack];
        [_delegate refreshData];
    }
    
    else if (_delegate && [_delegate respondsToSelector:callBackSender])
    {
        [_delegate refreshData:self];
//        [_delegate performSelector:callBackSender withObject:self];
    }
    
    else
    {
        return;
    }
}

- (void)NIMRefreshCellDidTriggerLoading:(NIMRefreshCell*)view
{
    [self loadMore];
}

- (void)slimeRefreshStartRefresh:(NIMRefreshView*)refreshView
{
    [self refreshData];
}

- (void)QBRefreshStartRefresh:(NIMQBRefreshView*)refreshView
{
    [self refreshData];
}

- (BOOL)NIMRefreshCellDataSourceIsLoading:(NIMRefreshCell*)view
{
    return _footRefreshView.state == RefreshLoading;
}

- (void)showHeader:(BOOL)bshow
{
    if(bshow)
    {
//        [self qbHeadRefreshView];
        //[self.mainList addHeaderWithTarget:self action:@selector(qbf_refreshViewControlEventValueChanged:)];
    }
    else
    {
        //      [self.mainList removeHeader];
//        [self.qbHeadRefreshView removeFromSuperview];
//        self.qbHeadRefreshView.delegate = nil;
//        self.qbHeadRefreshView.scrollView = nil;
//        self.qbHeadRefreshView = nil;
    }
//    if(bshow)
//    {
//        if(!_qbm_currentHeadRefreshView)
//        {
//            [self qbm_currentHeadRefreshView];
//            
//        }
//
//        [self.mainList addSubview:self.qbm_refreshView];
//
//        [self.qbm_refreshView addSubview:self.qbm_currentHeadRefreshView];
//
//    }
//    else
//    {
//        self.sysHeadRefreshView.hidden = YES;
//        [self.qbm_refreshView removeFromSuperview];
//        self.qbm_refreshView = nil;
//        [self.qbm_currentHeadRefreshView removeFromSuperview];
//        self.qbm_currentHeadRefreshView = nil;
//    }
}

- (void)showFooter:(BOOL)bshow{
    /*
    if(bshow)
    {
//        [self footRefreshView];
        [self.mainList addFooterWithTarget:self action:@selector(NIMRefreshCellDidTriggerLoading:)];
         self.mainList.footerHidden = NO;
    }
    else
    {
//        [_footRefreshView removeFromSuperview];
//        RELEASE_SAFELY(_footRefreshView);
        [self.mainList footerEndRefreshing];
//        [self.mainList removeFooter];
        self.mainList.footerHidden = YES;
    }
    */
}

- (void)endFooterLoadState
{
    if(_footRefreshView)
    {
        [_footRefreshView refreshScrollViewDataSourceDidFinishedLoading:self.mainList succeed:YES animal:NO];
    }
    /*
    if(self.mainList.footerRefreshing)
    {
        [self.mainList footerEndRefreshing];
    }
    */
}

- (void)endHeaderRefreshState
{
    if(_headRefreshView)
    {
        [_headRefreshView endRefresh];
    }
    if (_sysHeadRefreshView)
    {
        [_sysHeadRefreshView endRefreshing];
    }
    if(_qbHeadRefreshView)
    {
        [_qbHeadRefreshView endRefresh];
    }
    //if(self.mainList.headerRefreshing)
    //{
    //    [self.mainList headerEndRefreshing];
    //}
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_qbHeadRefreshView scrollViewDidScroll];
    [_headRefreshView scrollViewDidScroll];
    [_footRefreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_qbHeadRefreshView scrollViewDidEndDraging];
    [_headRefreshView scrollViewDidEndDraging];
    [_footRefreshView refreshScrollViewDidEndDragging:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_qbHeadRefreshView scrollViewWillBeginDragging];
}


- (NIMRefreshCell *)footRefreshView
{
    if(!_footRefreshView)
    {
//        _footRefreshView = [NIMRefreshCell attachNIMRefreshCellTo:self.mainList
//                                                    delegate:self
//                                              arrowImageName:@"NIMRefreshCell_img_arrow.png"
//                                                   textColor:[UIColor darkGrayColor]
//                                              indicatorStyle:UIActivityIndicatorViewStyleGray
//                                                        type:RefreshTypeLoadMore];
    }
    return _footRefreshView;
}

- (NIMRefreshView*)headRefreshView
{
    if(!_headRefreshView)
    {
//        _headRefreshView = [[NIMRefreshView alloc] init];
//        _headRefreshView.delegate = self;
//        _headRefreshView.upInset = (IOS_VERSION >= 7.0) ? 64 : 0;
//        _headRefreshView.slimeMissWhenGoingBack = YES;
//        _headRefreshView.slime.bodyColor = kPushRefreshBodyColor;
//        _headRefreshView.slime.skinColor = kPushRefreshSkinColor;
//        _headRefreshView.slime.lineWith = 1;
    }
    
    return _headRefreshView;
}


- (NIMQBRefreshView *)qbHeadRefreshView
{
    if(!_qbHeadRefreshView)
    {
//        _qbHeadRefreshView = [[QBRefreshView alloc] init];
//        _qbHeadRefreshView.backgroundColor = _COLOR_CLEAR;
//        _qbHeadRefreshView.delegate = self;
    }
    return _qbHeadRefreshView;
}

- (UIRefreshControl*)sysHeadRefreshView
{
    if(!_sysHeadRefreshView)
    {
//        _sysHeadRefreshView = [[UIRefreshControl alloc]init];
//        _sysHeadRefreshView.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//        [_sysHeadRefreshView addTarget:self action:@selector(qbf_refreshViewControlEventValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _sysHeadRefreshView;
}

- (UIView*)qbm_refreshView
{
    if(!_qbm_refreshView)
    {
//        _qbm_refreshView = [[UIView alloc]init];
    }
    return _qbm_refreshView;
}

- (UIView *)qbm_currentHeadRefreshView
{
    if(self.qbm_systemRefresh)
    {
        return self.sysHeadRefreshView;
    }
    else
    {
        return self.headRefreshView;
    }
}

- (void)qbf_refreshViewControlEventValueChanged:(id)headRefresh
{
    [self refreshData];
//    UIRefreshControl *sender = (UIRefreshControl*)headRefresh;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [sender beginRefreshing];
//    });


//    [sender layoutIfNeeded];
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
//    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新日期 %@",
//                             [formatter stringFromDate:[NSDate date]]];
//    self.sysHeadRefreshView.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

- (void)setUpInsetTop:(CGFloat)upInsetTop
{
    self.headRefreshView.upInset = upInsetTop;
}

//适用于footRefreshView适配
- (void)setContentInsetTop:(CGFloat)upInsetTop
{
    self.footRefreshView.upInsetVal = upInsetTop;
}

- (void)didSelectedRowWithData:(NIMBaseDataModel*)data atIndexPath:(NSIndexPath*)indexPath
{
    
}

@end
