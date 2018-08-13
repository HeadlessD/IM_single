//
//  NIMRefreshCell.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NIMRefreshCell.h"
#import <AudioToolbox/AudioToolbox.h>

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface NIMRefreshCell () {
    
    SystemSoundID soundTrigger;
    SystemSoundID soundRelease;
    __weak UIScrollView *_scrollview;
}
@property (weak, nonatomic) UIScrollView *scrollview;
@end

@implementation NIMRefreshCell

@synthesize delegate=_delegate;
@synthesize type = _type;
@synthesize state = _state;
@synthesize scrollview = _scrollview;

+ (NIMRefreshCell *)attachNIMRefreshCellTo:(UIScrollView *)scrollview
                            delegate:(id<NIMRefreshCellDelegate>)delegate
                      arrowImageName:(NSString *)arrow
                           textColor:(UIColor *)textColor
                      indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
                                type:(RefreshType)type{
    CGFloat y = -60;
    if (RefreshTypeLoadMore == type) {
        y = MAX(scrollview.contentSize.height, CGRectGetHeight(scrollview.bounds));
    }
    NIMRefreshCell *cell = [[NIMRefreshCell alloc] initWithFrame:CGRectMake(0,
                                                                      y,
                                                                      CGRectGetWidth(scrollview.bounds),
                                                                      60)
                                            arrowImageName:arrow
                                                 textColor:textColor
                                            indicatorStyle:indicatorStyle
                                                      type:type];
    cell.delegate = delegate;
    [scrollview addSubview:cell];
    
    [cell attachToScrollview:scrollview];
    
    return cell;
}

- (void)attachToScrollview:(UIScrollView *)scrollview{
    if (RefreshTypeLoadMore == self.type) {
        if (nil!=_scrollview &&
            _scrollview==self.superview) {
            [_scrollview removeObserver:self forKeyPath:@"contentSize"];
        }
        
        self.scrollview = scrollview;
        
        [scrollview addObserver:self
                     forKeyPath:@"contentSize"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        
        CGFloat y = MAX(scrollview.contentSize.height, CGRectGetHeight(scrollview.bounds));
        self.frame = CGRectMake(0,
                                y,
                                CGRectGetWidth(scrollview.bounds),
                                60);
        [scrollview addSubview:self];
    }else{
        self.frame = CGRectMake(0,
                                -60,
                                CGRectGetWidth(scrollview.bounds),
                                60);
        [scrollview addSubview:self];
    }
}

- (void)detach{
    if (RefreshTypeLoadMore == self.type &&
        nil!=_scrollview ) {
        
        [_scrollview removeObserver:self forKeyPath:@"contentSize"];
        
        UIEdgeInsets inset = _scrollview.contentInset;
        inset.bottom = 0;
        _scrollview.contentInset = inset;
        
        self.scrollview = nil;
    }
    
    [self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow
          textColor:(UIColor *)textColor
     indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
               type:(RefreshType)type{
    
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        
        _type = type;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        if (_type == RefreshTypeRefresh) {
            label.frame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
        } else {
            label.frame = CGRectMake(0.0f, 30.0f, self.frame.size.width, 20.0f);
        }
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = FONT_TITLE(9.0);
        
		label.textColor = textColor;
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = ALIGN_CENTER;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        RELEASE_SAFELY(label);
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        if (_type == RefreshTypeRefresh) {
            label.frame = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
            UIImage *icon = IMGGET(@"refresh_img_icon.png");
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                  -icon.size.height,
                                                                                  self.frame.size.width,
                                                                                  icon.size.height)];
            iconView.contentMode = UIViewContentModeCenter;
            iconView.image = icon;
            [self addSubview:iconView];
//            [iconView release]; iconView = nil;
            RELEASE_SAFELY(iconView);
        } else {
            label.frame = CGRectMake(0.0f, 22.0f, self.frame.size.width, 20.0f);
        }
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = FONT_TITLE(12.0);
		label.textColor = textColor;
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = ALIGN_CENTER;
		[self addSubview:label];
		_statusLabel=label;
//		[label release];
//        RELEASE_SAFELY(label);
		
		CALayer *layer = [CALayer layer];
        UIImage *image = IMGGET(arrow);
        if (_type == RefreshTypeRefresh) {
            layer.frame = CGRectMake(CGRectGetMidX(label.frame)-50-image.size.width,
                                     floor(CGRectGetMidY(label.frame)-image.size.height/2),
                                     image.size.width,
                                     image.size.height);
        } else {
            layer.frame = CGRectMake(CGRectGetMidX(label.frame)-70-image.size.width,
                                     floor(CGRectGetMidY(label.frame)-image.size.height/2),
                                     image.size.width,
                                     image.size.height);
        }
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)image.CGImage;
		 RELEASE_SAFELY(label);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        if (_type == RefreshTypeRefresh) {
            view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, view.frame.size.width, view.frame.size.height);
        } else {
            view.frame = CGRectMake(25.0f, 22.0f, view.frame.size.width, view.frame.size.height);
        }
		[self addSubview:view];
		_activityView = view;
//		[view release];
        RELEASE_SAFELY(view);
        
		[self setState:RefreshNormal];
        
//注掉刷新声音
//        NSURL *tapSound = [[NSBundle mainBundle] URLForResource:@"refresh_triggering"
//                                                  withExtension:@"wav"];
//        AudioServicesCreateSystemSoundID((CFURLRef)tapSound,&soundTrigger);
//        tapSound = [[NSBundle mainBundle] URLForResource:@"refresh_release"
//                                           withExtension:@"wav"];
//        AudioServicesCreateSystemSoundID((CFURLRef)tapSound,&soundRelease);
        
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame type:RefreshTypeRefresh];
}

- (id)initWithFrame:(CGRect)frame type:(RefreshType)type {
    return [self initWithFrame:frame
                arrowImageName:@"blueArrow.png"
                     textColor:TEXT_COLOR
                indicatorStyle:UIActivityIndicatorViewStyleGray
                          type:type];
}

#pragma mark - public
- (void)reloadData{
    UIScrollView *scrollview = (id)self.superview;
    if (nil==scrollview ||
        RefreshTypeRefresh!=self.type) {
        return;
    }
    
    [scrollview scrollRectToVisible:CGRectMake(scrollview.contentOffset.x,
                                               0,
                                               CGRectGetWidth(scrollview.bounds),
                                               CGRectGetHeight(scrollview.bounds))
                           animated:NO];
    UIEdgeInsets inset = scrollview.contentInset;
    CGFloat offset = MAX(CGRectGetHeight(self.bounds), 60);
    scrollview.contentInset = UIEdgeInsetsMake(offset, 0.0f, inset.bottom, 0.0f);
    scrollview.contentOffset = CGPointMake(scrollview.contentOffset.x, -1*offset);
    [self setState:RefreshLoading];
    if ([_delegate respondsToSelector:@selector(NIMRefreshCellDidTriggerLoading:)]) {
        AudioServicesPlaySystemSound(soundTrigger);
        [_delegate NIMRefreshCellDidTriggerLoading:self];
    }
}

#pragma mark - override


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(NIMRefreshCellDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate NIMRefreshCellDataSourceLastUpdated:self];
		if (date) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            //            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            //            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            
            if (_type == RefreshTypeRefresh) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [dateFormatter stringFromDate:date]];
                if (nil!=_lastUpdatedLabel.text) {
                    setObjectToUserDefault(@"NIMRefreshCell_LastRefresh", _lastUpdatedLabel.text);
                }
            } else {
                _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", @"上次加载", [dateFormatter stringFromDate:date]];
                if (nil!=_lastUpdatedLabel.text) {
                    setObjectToUserDefault(@"NIMRefreshCell_LastLoadMore", _lastUpdatedLabel.text);
                }
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            _lastUpdatedLabel.text = nil;
        }
	} else {
		
		_lastUpdatedLabel.text = nil;
	}
    
}

- (void)setState:(RefreshState)aState{
	
	switch (aState) {
		case RefreshPulling:
			if (_type == RefreshTypeRefresh) {
                _statusLabel.text = @"松开即可更新...";
            } else {
                _statusLabel.text = @"松开即可加载更多内容...";
            }
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            if (_type == RefreshTypeRefresh) {
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            } else {
                _arrowImage.transform = CATransform3DIdentity;
            }
			[CATransaction commit];
			
			break;
		case RefreshNormal:
			
			if (_state == RefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                if (_type == RefreshTypeRefresh) {
                    _arrowImage.transform = CATransform3DIdentity;
                } else {
                    _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                }
				[CATransaction commit];
			}
			
            if (_type == RefreshTypeRefresh) {
                _statusLabel.text = @"下拉即可更新...";
            } else {
                _statusLabel.text = @"上拉即可加载更多内容...";
            }
            
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            if (_type == RefreshTypeRefresh) {
                _arrowImage.transform = CATransform3DIdentity;
            } else {
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case RefreshLoading:
			
            if (_type == RefreshTypeRefresh) {
                _statusLabel.text = @"正在更新...";
            } else {
                _statusLabel.text = @"正在加载更多内容...";
            }
            
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == RefreshLoading) {
		UIEdgeInsets inset = scrollView.contentInset;
        
        if (_type == RefreshTypeRefresh) {
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, inset.bottom, 0.0f);
        } else {
            CGFloat offset = MAX(scrollView.contentOffset.y, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(inset.top, 0.0f, offset, 0.0f);
        }
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(NIMRefreshCellDataSourceIsLoading:)]) {
			_loading = [_delegate NIMRefreshCellDataSourceIsLoading:self];
		}
		
        if (_type == RefreshTypeRefresh) {
            
            if (_state == RefreshPulling &&
                scrollView.contentOffset.y > -65.0f &&
                scrollView.contentOffset.y < 0.0f && !_loading) {
                [self setState:RefreshNormal];
            } else if (_state == RefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
                [self setState:RefreshPulling];
            }
            
        } else {
            
            if (_state == RefreshPulling &&
                scrollView.contentOffset.y < scrollView.contentSize.height-scrollView.frame.size.height+65.0f &&
                scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height+0.0f && !_loading) {
                [self setState:RefreshNormal];
            } else if (_state == RefreshNormal && scrollView.contentOffset.y >scrollView.contentSize.height-scrollView.frame.size.height+65.0f && !_loading) {
                [self setState:RefreshPulling];
            }
            
        }
        
        UIEdgeInsets inset = scrollView.contentInset;
		if (_type == RefreshTypeRefresh) {
            if (scrollView.contentInset.top != 0) {
                scrollView.contentInset = UIEdgeInsetsMake(0,0,inset.bottom,0);
            }
        } else {
            if (scrollView.contentInset.bottom != 0) {
                scrollView.contentInset = UIEdgeInsetsMake(inset.top,0,0,0);
            }
        }
	}
	
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    [self refreshScrollViewDidEndDragging:scrollView animal:YES];
}

#pragma mark -- add by Zt
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView animal:(BOOL)animal
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(NIMRefreshCellDataSourceIsLoading:)]) {
		_loading = [_delegate NIMRefreshCellDataSourceIsLoading:self];
	}
	
    if (_loading) {
        return;
    }
    
    if (_type == RefreshTypeRefresh) {
        if (scrollView.contentOffset.y <= - 65.0f)
        {
            //modify by Zt begin
            [self setState:RefreshLoading];
            if(animal)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                [UIView commitAnimations];
            }
            else
            {
                scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            }
            if ([_delegate respondsToSelector:@selector(NIMRefreshCellDidTriggerLoading:)]) {
                AudioServicesPlaySystemSound(soundTrigger);
                [_delegate NIMRefreshCellDidTriggerLoading:self];
            }
            //modify by Zt end
            
        }
    } else {

        if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height+65.0f &&
            (scrollView.contentOffset.y > 0))
        {
            [self setState:RefreshLoading];
            //modify by Zt begin
            if(animal)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
                [UIView commitAnimations];
            }
            else
            {
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
            }
            if ([_delegate respondsToSelector:@selector(NIMRefreshCellDidTriggerLoading:)]) {
                AudioServicesPlaySystemSound(soundTrigger);
                [_delegate NIMRefreshCellDidTriggerLoading:self];
            }
            //modify by Zt end
        }
    }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [self refreshScrollViewDataSourceDidFinishedLoading:scrollView succeed:NO];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView succeed:(BOOL)succeed
{
    [self refreshScrollViewDataSourceDidFinishedLoading:scrollView succeed:succeed animal:YES];
}

#pragma mark -- add by Zt
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView succeed:(BOOL)succeed animal:(BOOL)animal
{
    [self setState:RefreshNormal];
    
    if (succeed) {
        if(animal)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.3];
            CGFloat bottom = scrollView.contentInset.bottom;
            DLog(@"bottom:%f", bottom);
            [scrollView setContentInset:UIEdgeInsetsMake(self.upInsetVal, 0.0f, scrollView.contentInset.bottom, 0.0f)];
            [UIView commitAnimations];
        }
        else
        {
//            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, scrollView.contentInset.bottom, 0.0f)];  //替换掉
            [scrollView setContentInset:UIEdgeInsetsMake(self.upInsetVal, 0.0f, 0.0f, 0.0f)];
        }
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [scrollView setContentInset:UIEdgeInsetsMake(self.upInsetVal, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
    }
    
    AudioServicesPlaySystemSound(soundRelease);
}

- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object
						 change:(NSDictionary *)change
						context:(void *)context {
	if ([keyPath isEqual:@"contentSize"]) {
        if (RefreshTypeLoadMore==self.type) {
            CGFloat y = MAX(self.scrollview.contentSize.height, CGRectGetHeight(self.scrollview.bounds));
            self.frame = CGRectMake(0,
                                    y,
                                    CGRectGetWidth(self.scrollview.bounds),
                                    60);;
        }
	}
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [self detach];
    
    AudioServicesDisposeSystemSoundID(soundTrigger);
    AudioServicesDisposeSystemSoundID(soundRelease);
    
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    
//    [super dealloc];
}


@end
