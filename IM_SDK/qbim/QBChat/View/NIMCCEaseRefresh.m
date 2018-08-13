//
//  NIMCCEaseRefresh.m
//  NIMCCEaseRefresh
//
//  Created by v－ling on 15/9/18.
//  Copyright (c) 2015年 LiuZeChen. All rights reserved.
//

#import "NIMCCEaseRefresh.h"
#import <QuartzCore/QuartzCore.h>

#define kRefreshViewHeight 80//64  下拉的总高速
#define kStatusNavNumHeight 64 //状态栏和导航栏的总高度
#define kTimeViewHeight    15
#define kTimeBottomEdage   8
#define kSubviewEdage      7
//#define kBallImage         [UIImage imageNamed:@"refresh_sphere"]
#define kBallImage         IMGGET(@"19")
#define kContentOffset     @"contentOffset"
#define kAttributeDict     @{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}

@interface NIMCCEaseRefresh () {
    CGFloat _ballWidth;     ///< 球的宽
    CGFloat _ballHeight;    ///< 球的高
    CGFloat _circleWidth;   ///< 圆的宽
    CGFloat _circleHeight;  ///< 圆的高
    CGFloat _defaultBallY;  ///< 球的初始Y
    CGFloat _textX;         ///< 文本的X
    CGFloat _textY;         ///< 文本的Y
    CGFloat _currentOffsetY;///< scrollView的当前offset的Y
    
    UIImageView *ballImage;
    int count;
    NSTimer *myTimer;
    CGSize textSize;
    CGFloat ballLayerMinY;
    
    NSString *firstText;
    NSString *secondText;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) CALayer       *ballLayer;
@property (nonatomic, strong) CALayer       *circleLayer;
@property (nonatomic, copy)   NSString      *lastUpdateTimeString;
@property (nonatomic, assign) UIEdgeInsets  originalContentInset;

@end

@implementation NIMCCEaseRefresh

#pragma mark - 初始、释放
- (instancetype)initInScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectMake(0, scrollView.contentInset.top-kRefreshViewHeight, scrollView.frame.size.width, kRefreshViewHeight)];
    if (self) {
        NSAssert(scrollView, @"NIMCCEaseRefresh's scrollView can't is nil");

        self.scrollView = scrollView;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];

        [self.scrollView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView insertSubview:self belowSubview:scrollView];

        [self loadComponent];
        
        count = 0;
    }
    return self;
}

- (void)dealloc {
    printf("NIMCCEaseRefresh(OC) deinit...\n");
    [self.scrollView removeObserver:self forKeyPath:kContentOffset];
    self.scrollView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:kContentOffset];
        self.scrollView = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    [self calcTextXY];
    //    [_lastUpdateTimeString drawAtPoint:CGPointMake(_textX, _textY) withAttributes:kAttributeDict];

    // 下拉时颜色为黑色，松开时为橘黄色
    if ([firstText isEqualToString:CCEaseFirstTextPull]) {
        NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
        [firstText drawAtPoint:CGPointMake(_textX, _textY) withAttributes:dic];
    }
    else
    {
        NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor orangeColor]};
        [firstText drawAtPoint:CGPointMake(_textX, _textY) withAttributes:dic];
    }
    
    
    CGSize secSize = [CCEaseFirstTextPull boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:kAttributeDict context:nil].size;
     NSDictionary *dicAnother =@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSStrokeColorAttributeName:[[UIColor greenColor] colorWithAlphaComponent:0.5]};
    [secondText drawAtPoint:CGPointMake(_textX + secSize.width, _textY) withAttributes:dicAnother];
}

- (void)calcTextXY {
    if (_textY == 0 || _textX == 0) {
        _lastUpdateTimeString = CCEaseTitleLength;
        textSize = [_lastUpdateTimeString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:kAttributeDict context:nil].size;
        _textY = self.frame.size.height - textSize.height - kSubviewEdage;
        _textX = (self.frame.size.width - textSize.width) / 2;
        
//        DBLog(@"初始化的文本地点：%f", _textY);
    }
}

#pragma mark - 加载零件
- (void)loadComponent {
    [self updateTime];
    [self calcTextXY];
    
    _ballWidth = kBallImage.size.width   - kSubviewEdage / 2;
    _ballHeight = kBallImage.size.height - kSubviewEdage / 2;
    _ballLayer = [CALayer layer];
    _ballLayer.frame = CGRectMake((self.frame.size.width - _ballWidth) / 2, -_ballHeight, _ballWidth, _ballHeight);
    _ballLayer.position = CGPointMake(self.center.x, _ballLayer.position.y);
    _ballLayer.contents = (id)kBallImage.CGImage;
    _ballLayer.masksToBounds = YES;
    _defaultBallY = _ballLayer.frame.origin.y;

    // 添加到self、设置透明度
    [self setAlpha:0.f];
    [self.layer addSublayer:_ballLayer];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kContentOffset]) {
        // offset
        _currentOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y - kStatusNavNumHeight;
        // 判断是否可以进入刷新状态
        CGFloat newOffsetThreshold = -_originalContentInset.top - kStatusNavNumHeight;
        
//        DBLog(@"偏移量：%f", _currentOffsetY);
//        DBLog(@"顶部：%f", newOffsetThreshold); -0.000000


        if (_refreshState == NIMCCEaseRefreshStateLoading || _currentOffsetY > newOffsetThreshold) {return;}

        if (!self.scrollView.isDragging && _refreshState == NIMCCEaseRefreshStateTrigger) {
            self.refreshState = NIMCCEaseRefreshStateLoading;
        }else if (_currentOffsetY <= (-kRefreshViewHeight+newOffsetThreshold)/*newOffsetThreshold * 2*/ && self.scrollView.isDragging) {
            self.refreshState = NIMCCEaseRefreshStateTrigger;
        }else if (_currentOffsetY < newOffsetThreshold && _currentOffsetY > (-kRefreshViewHeight+newOffsetThreshold)/*newOffsetThreshold * 2*/  && _refreshState != NIMCCEaseRefreshStateLoading) {
            self.refreshState = NIMCCEaseRefreshStateVisible;
        }else if (_currentOffsetY >= newOffsetThreshold && _refreshState != NIMCCEaseRefreshStateDefault && _refreshState != NIMCCEaseRefreshStateLoading) {
            // refreshState != CCRefreshDefault:进入默认状态后,在没有做上拉或下拉刷新时,不给refreshState的setter方法,从而启到优化程序的作用.想让谁少走几次owner != owner.
            self.refreshState = NIMCCEaseRefreshStateDefault;
        }
        return;
    }
}

#pragma mark - set方法群
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _originalContentInset = _scrollView.contentInset;
    _scrollView.backgroundColor = [UIColor clearColor];
}

- (void)setRefreshState:(NIMCCEaseRefreshState)refreshState {
    _refreshState = refreshState;
    switch (_refreshState) {
        case NIMCCEaseRefreshStateDefault:
        {
            // DBLog(@"默认状态");
            [self updateTime];
            [self updateContentInset:_originalContentInset];
        }
            break;
        case NIMCCEaseRefreshStateVisible:
        {
            // DBLog(@"下拉消除全部未读提醒");
            [self updateTime];
            [self updateBallLayerPosition];
        }
            break;
        case NIMCCEaseRefreshStateTrigger:
        {
            // DBLog(@"松开消除全部未读提醒");
            [self updateTime];
            ballLayerMinY = 26;
            _ballLayer.position = CGPointMake(_ballLayer.position.x, ballLayerMinY);
            _textY = ballLayerMinY + kSubviewEdage + 5 + 15;
        }
            break;
        case NIMCCEaseRefreshStateLoading:
        {
            // DBLog(@"松开消失");
            UIEdgeInsets ei = _originalContentInset;
            ei.top = ei.top + kRefreshViewHeight;
            [self updateContentInset:ei];
            [self updateTime];
            
            [self dismissAn];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
            break;
        default:
            break;
    }
}

-(void)timerFired
{
    if (count == 10) {
        count = 0;
        [myTimer invalidate];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"2%d", count];
    
    _ballLayer.contents = (id)IMGGET(path).CGImage;
    count ++;
}

- (void)dismissAn
{
    myTimer = [NSTimer  timerWithTimeInterval:0.08 target:self selector:@selector(timerFired)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    [myTimer fire];
}

#pragma mark - 更新(Layer的Frame、刷新的时间)
- (void)updateBallLayerPosition {
    // fabs(_currentOffsetY) - _originalContentInset.top从0.f开始升序
    ballLayerMinY = fabs(_currentOffsetY) - /**_originalContentInset.top + _defaultBallY -10 - **/ kStatusNavNumHeight;
//    CGFloat ballLayerMaxY = _textY - kSubviewEdage - _ballHeight / 2 +10;
//    if (ballLayerMinY >= ballLayerMaxY) {
//        ballLayerMinY  = ballLayerMaxY;
//    }
    if (ballLayerMinY > 26) {
        ballLayerMinY = 26;
    }
//    DBLog(@"位移:%f", _currentOffsetY);
    
//    float move = kStatusNavNumHeight + kRefreshViewHeight;  // 64+80=144
    
    
    for (int i = 0; i < 10; i++) {
        if (fabs(_currentOffsetY)>104+4*i && fabs(_currentOffsetY)<=104+4*(i+1)) {
            
            NSString *path = [NSString stringWithFormat:@"1%d", i];
            
            _ballLayer.contents = (id)IMGGET(path).CGImage;
//            DBLog(@"当前图片为：1%d", i);
        }
    }

    // 去掉隐式动画
    // 1.
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _ballLayer.position = CGPointMake(_ballLayer.position.x, ballLayerMinY);
    _textY = ballLayerMinY + kSubviewEdage + 5 + 15;
    [CATransaction commit];
    // 2.
    _ballLayer.actions = @{@"position":[NSNull null]};
    
//    DBLog(@"最终的位置:%f, %f", _ballLayer.position.x, ballLayerMinY);

    // 更新self的透明度
    self.alpha = (fabs(_currentOffsetY) - _originalContentInset.top - kStatusNavNumHeight) / kRefreshViewHeight;
    self.layer.hidden = NO;
}

// 更新contentInset
- (void)updateContentInset:(UIEdgeInsets)ei {
    [UIView animateWithDuration:.25 animations:^{
        _scrollView.contentInset = ei;
    }];
}

- (void)updateTime {
    switch (_refreshState) {
        case NIMCCEaseRefreshStateDefault:
        case NIMCCEaseRefreshStateVisible:
        {
//            _lastUpdateTimeString = CCEaseDefaultTitle;
            // 下拉消除全部未读提醒
            firstText = CCEaseFirstTextPull;
            secondText = CCEaseSecondText;
            
            break;
        }
        case NIMCCEaseRefreshStateTrigger:
        {
//            _lastUpdateTimeString = CCEaseTriggertTitle;
            // 松开消除全部未读提醒
            firstText = CCEaseFirstTextUp;
            secondText = CCEaseSecondText;
            
            break;
        }
        case NIMCCEaseRefreshStateLoading:
        {
//            _lastUpdateTimeString = CCEaseLoadingTitle;
            // 松开消除全部未读提醒
            firstText = CCEaseFirstTextUp;
            secondText = CCEaseSecondText;
            
            break;
        }
        default:
            break;
    }
    [self setNeedsDisplay];
}

#pragma mark - 开始刷新、结束刷新
- (void)beginRefreshing {
    if (_refreshState != NIMCCEaseRefreshStateLoading) {
        self.refreshState = NIMCCEaseRefreshStateDefault;
    }
}

- (void)endRefreshing {
    if (_refreshState != NIMCCEaseRefreshStateDefault) {
        self.refreshState = NIMCCEaseRefreshStateDefault;
        self.alpha = 0.f;
        self.layer.hidden = YES;

        _ballLayer.position = CGPointMake(_ballLayer.position.x, _defaultBallY);
        _textY = 0;
        ballLayerMinY = 0;
    }
}

@end
