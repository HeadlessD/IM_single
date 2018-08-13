//
//  QBRefreshView.m
//  QianbaoIM
//
//  Created by qianwang2 on 14-6-13.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMQBRefreshView.h"
typedef enum HZActivityIndicatorDirection
{
    HZActivityIndicatorDirectionClockwise = -1,
    HZActivityIndicatorDirectionCounterClockwise = 1
} HZActivityIndicatorDirection;

@interface HZActivityIndicatorView : UIView
{
    NSUInteger                      _steps;
    CGFloat                         _stepDuration;
    BOOL                            _isAnimating;
    
    UIColor                         *_color;
    BOOL                            _hidesWhenStopped;
    UIRectCorner                    _roundedCoreners;
    CGSize                          _cornerRadii;
    CGSize                          _finSize;
    HZActivityIndicatorDirection    _direction;
    UIActivityIndicatorViewStyle    _actualActivityIndicatorViewStyle;
}

@property (nonatomic) NSUInteger                    steps;
@property (nonatomic) NSUInteger                    indicatorRadius;
@property (nonatomic) CGFloat                       stepDuration;
@property (nonatomic) CGSize                        finSize;
@property (nonatomic, strong) UIColor               *color;
@property (nonatomic) UIRectCorner                  roundedCoreners;
@property (nonatomic) CGSize                        cornerRadii;
@property (nonatomic) HZActivityIndicatorDirection  direction;
@property (nonatomic) UIActivityIndicatorViewStyle  activityIndicatorViewStyle;

@property(nonatomic) BOOL                           hidesWhenStopped;

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (CGPathRef)finPathWithRect:(CGRect)rect;

@end


@interface HZActivityIndicatorView ()
{
    NSTimer     *_timer;
    CGFloat     _anglePerStep;
    CGFloat     _currStep;
}

- (void)_repeatAnimation:(NSTimer*)timer;
- (UIColor*)_colorForStep:(NSUInteger)stepIndex;
- (void)_setPropertiesForStyle:(UIActivityIndicatorViewStyle)style;

@end

@implementation HZActivityIndicatorView
@synthesize steps = _steps;
@synthesize indicatorRadius = _indicatorRadius;
@synthesize finSize = _finSize;
@synthesize color = _color;
@synthesize stepDuration = _stepDuration;
@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize roundedCoreners = _roundedCoreners;
@synthesize cornerRadii = _cornerRadii;
@synthesize direction = _direction;
@synthesize activityIndicatorViewStyle = _actualActivityIndicatorViewStyle;

- (void)awakeFromNib
{
    [self _setPropertiesForStyle:UIActivityIndicatorViewStyleWhite];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _setPropertiesForStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        [self _setPropertiesForStyle:style];
    }
    return self;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    [self _setPropertiesForStyle:activityIndicatorViewStyle];
}

- (void)_setPropertiesForStyle:(UIActivityIndicatorViewStyle)style
{
    self.backgroundColor = [UIColor clearColor];
    self.direction = HZActivityIndicatorDirectionClockwise;
    self.roundedCoreners = UIRectCornerAllCorners;
    self.cornerRadii = CGSizeMake(1, 1);
    self.stepDuration = 0.1;
    self.steps = 12;
    
    switch (style) {
        case UIActivityIndicatorViewStyleGray:
        {
            self.color = [UIColor darkGrayColor];
            self.finSize = CGSizeMake(2, 5);
            self.indicatorRadius = 5;
            
            break;
        }
            
        case UIActivityIndicatorViewStyleWhite:
        {
            self.color = [UIColor whiteColor];
            self.finSize = CGSizeMake(2, 5);
            self.indicatorRadius = 5;
            
            break;
        }
            
        case UIActivityIndicatorViewStyleWhiteLarge:
        {
            self.color = [UIColor whiteColor];
            self.cornerRadii = CGSizeMake(2, 2);
            self.finSize = CGSizeMake(3, 9);
            self.indicatorRadius = 8.5;
            
            break;
        }
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"style invalid"];
            break;
    }
    
    _isAnimating = NO;
    if (_hidesWhenStopped)
        self.hidden = YES;
}

#pragma mark - UIActivityIndicator

- (void)startAnimating
{
    _currStep = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_stepDuration target:self selector:@selector(_repeatAnimation:) userInfo:nil repeats:YES];
    _isAnimating = YES;
    
    if (_hidesWhenStopped)
        self.hidden = NO;
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    if (_hidesWhenStopped)
        self.hidden = YES;
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

#pragma mark - HZActivityIndicator Drawing.

- (void)setIndicatorRadius:(NSUInteger)indicatorRadius
{
    _indicatorRadius = indicatorRadius;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            _indicatorRadius*2 + _finSize.height*2,
                            _indicatorRadius*2 + _finSize.height*2);
    [self setNeedsDisplay];
}

- (void)setSteps:(NSUInteger)steps
{
    _anglePerStep = (360/steps) * M_PI / 180;
    _steps = steps;
    [self setNeedsDisplay];
}

- (void)setFinSize:(CGSize)finSize
{
    _finSize = finSize;
    [self setNeedsDisplay];
}

- (UIColor*)_colorForStep:(NSUInteger)stepIndex
{
    CGFloat alpha = 1.0;
    
    if(_currStep == stepIndex)
    {
        alpha = 1.0;
    }
    else
    {
        
    }
    float oneSteps = 1.0/_steps;
    
    if(_isAnimating)
    {
        int all = _currStep + _steps - stepIndex -1;
        
        int off = all % _steps;
        
        alpha = ( _steps - off ) * oneSteps;
        if(alpha == 0)
        {
            alpha = 1;
        }
//        NSLog(@"%f===%d===%f",_currStep,stepIndex,alpha);
    }
    else
    {
        if(_currStep > stepIndex)
        {
            alpha  = 1;
        }
        else
        {
            alpha = 0;
        }
    }
    CGColorRef ref = CGColorCreateCopyWithAlpha(self.color.CGColor, alpha);
    UIColor* returnColor = [UIColor colorWithCGColor:ref];
    CGColorRelease(ref);
    return returnColor;
}

- (void)_repeatAnimation:(NSTimer*)timer
{
    if(_currStep >= _steps)
    {
        _currStep = 0;
    }
    else
    {
        _currStep ++;
    }
    [self setNeedsDisplay];
}

- (void)_repeatAnimationWithStep:(NSUInteger)stepIndex
{
    if(stepIndex >_steps)
    {
        _currStep = 0;
    }
    else
    {
        _currStep = stepIndex;
    }
    [self setNeedsDisplay];
}


- (CGPathRef)finPathWithRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:_roundedCoreners
                                                           cornerRadii:_cornerRadii];
    CGPathRef path = CGPathCreateCopy([bezierPath CGPath]);
    return path;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect finRect = CGRectMake(self.bounds.size.width/2 - _finSize.width/2, 0,
                                _finSize.width, _finSize.height);
    CGPathRef bezierPath = [self finPathWithRect:finRect];
    
    for (int i = 0; i < _steps; i++)
    {
        [[self _colorForStep:i] set];
        
        CGContextBeginPath(context);
        CGContextAddPath(context, bezierPath);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        CGContextTranslateCTM(context, self.bounds.size.width / 2, self.bounds.size.height / 2);
        CGContextRotateCTM(context, _anglePerStep);
        CGContextTranslateCTM(context, -(self.bounds.size.width / 2), -(self.bounds.size.height / 2));
    }
}


@end




@interface NIMQBRefreshView()

@property (nonatomic, assign)CGRect                      selfFrame;
@property (nonatomic, strong)UIActivityIndicatorView    *loadingView;
@property (nonatomic, strong)UILabel                    *tipView;
@property (nonatomic, strong)HZActivityIndicatorView    *activityIndicator;
@property (nonatomic, assign)BOOL                        loading;
@property (nonatomic, assign)BOOL                         touching;

@end

@implementation NIMQBRefreshView

- (void)dealloc
{
    [[self class]cancelPreviousPerformRequestsWithTarget:self];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if(self.selfFrame.size.height == 0)
    {
        self.selfFrame = frame;

        self.activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.activityIndicator.finSize = CGSizeMake(2, 7);
        self.activityIndicator.indicatorRadius = 5;
//        self.activityIndicator.stepDuration    =3;
        self.activityIndicator.color = [SSIMSpUtil getColor:@"575f6c"];

        self.activityIndicator.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        [self addSubview:self.activityIndicator];
        
        self.tipView = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.activityIndicator.frame), self.frame.size.width, 24)];
        
        self.tipView.textColor = [SSIMSpUtil getColor:@"3f3f3f"];
        self.tipView.textAlignment = NSTextAlignmentCenter;
        self.tipView.text = @"下拉刷新";
        self.tipView.font = FONT_TITLE(12);
        [self addSubview:self.tipView];
        self.alpha = .0;
    }
}

- (void)scrollViewDidScroll
{
    if(!self.loading)
    {
        CGPoint p = _scrollView.contentOffset;
        CGRect frame =  self.selfFrame;
        frame.origin.y -= p.y;
        int step = ((-p.y)/5);
        
        self.alpha = step/13.0;

        if(step >= 13)
        {
            self.loading = YES;
            [self.activityIndicator _repeatAnimationWithStep:12];
            if(self.touching == NO)
            {
                self.loading = NO;
                [UIView animateWithDuration:.2 animations:^{
                    self.alpha = .0;
                }];
            }
        }
        else
        {
            [self.activityIndicator _repeatAnimationWithStep:step];
        }
    }
    
}

- (void)scrollViewDidEndDraging
{
    self.touching = NO;
    UIEdgeInsets inset = _scrollView.contentInset;
    if(self.loading)
    {
       
        [self.activityIndicator startAnimating];
    

        inset.top = self.frame.size.height;
        _scrollView.contentInset = inset;
        [self performSelector:@selector(endLoading) withObject:self afterDelay:0.2];
    }
    else
    {
        [self.activityIndicator stopAnimating];
        inset.top = 0;
        _scrollView.contentInset = inset;
        CGPoint p = _scrollView.contentOffset;
        CGRect frame =  self.selfFrame;
        frame.origin.y -= p.y;
        int step = ((-p.y)/5);
        [self.activityIndicator _repeatAnimationWithStep:step];
        
    }
}

- (void)scrollViewWillBeginDragging
{
    self.touching = YES;
}

- (void)endLoading
{
    if([_delegate respondsToSelector:@selector(QBRefreshStartRefresh:)])
    {
        [_delegate QBRefreshStartRefresh:self];
    }
}

- (void)endRefresh
{
    [self.activityIndicator stopAnimating];
    self.loading = NO;
    UIEdgeInsets inset = _scrollView.contentInset;
    inset.top = 0;
    _scrollView.contentInset = inset;
//    [_scrollView setContentOffset:CGPointZero animated:YES];
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = .0;
    }];
}

@end
