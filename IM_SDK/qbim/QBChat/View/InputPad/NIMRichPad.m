//
//  NIMRichPad.m
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRichPad.h"
#import "NIMQBLabel.h"
#import "WUEmoticonsKeyboardKeyItem.h"


@interface BigFaceClick : NSObject
@property (nonatomic, strong) NSString              * faceInfo;
@property (nonatomic, assign) NSTimeInterval          faceTime;

+ (id)bigFace:(NSString *)faceInfo;


@end

@implementation BigFaceClick

+ (id)bigFace:(NSString *)faceInfo
{
    BigFaceClick * face = [[BigFaceClick alloc] init];
    
    face.faceInfo = faceInfo;
    
    face.faceTime = [[NSDate date] timeIntervalSince1970];
    
    return face;
}

@end


@interface RichButton : UIButton
@property(nonatomic, strong)id info;

@end
@implementation RichButton

- (void)dealloc
{
    self.info = nil;
}

@end

@interface NIMRichPad() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *qqEmojiScrollView;
@property (nonatomic, strong) UIScrollView *qbEmojiScrollView;
@property (nonatomic, strong) UIScrollView *nimEmojiScrollView;

@property (nonatomic, strong) UIPageControl *qqEmojiPageControl;
@property (nonatomic, strong) UIPageControl *qbEmojiPageControl;


@property (nonatomic, strong) UIButton     *emojiBtnLeft;
@property (nonatomic, strong) UIButton     *emojiBtnRight;
@property (nonatomic, strong) UIButton     *sendBtn;
@property (nonatomic, assign) int           emojiType; // 0 表示左面的 1 表示右面的

@property (nonatomic, strong) NSMutableArray *historyBigEmoji;
@property (nonatomic, assign) int qqIndex;
@property (nonatomic, assign) int qbIndex;

@end


@implementation NIMRichPad


- (void)dealloc
{
    _qqEmojiScrollView      = nil;
    _qbEmojiScrollView      = nil;
    _nimEmojiScrollView     = nil;
    _emojiBtnLeft           = nil;
    _emojiBtnRight          = nil;
    
    _qqEmojiPageControl     = nil;
    _qbEmojiScrollView      = nil;
    _sendBtn                = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _canUseBigFace = NO;
        //[self addSubview:self.qbEmojiScrollView];
        //[self addSubview:self.qqEmojiScrollView];
        [self addSubview:self.nimEmojiScrollView];

        [self addSubview:self.emojiBtnLeft];
        [self addSubview:self.emojiBtnRight];
        [self addSubview:self.qqEmojiPageControl];
        [self addSubview:self.qbEmojiPageControl];
        self.qbEmojiPageControl.hidden = YES;
        [self addSubview:self.sendBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.bounds), 1)];
        [lineView setBackgroundColor:[SSIMSpUtil getColor:@"bbbbbb"]];
        [self addSubview:lineView];
       
        self.emojiType = 0;
        
        {
            NSDictionary *faces = [NIMQBLabel getFaceMap];
            NSMutableArray *faces_array = [[NSMutableArray alloc] initWithCapacity:faces.count];
            
            
            
            
            NSArray* arr = [faces allKeys];
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                NSComparisonResult result = [obj1 compare:obj2];
                return result==NSOrderedDescending;
            }];
            
            
            for (NSString *key in arr)
            {
                WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
                keyItem.image = IMGGET(key);
                keyItem.textToInput = [faces objectForKey:key];
                [faces_array addObject:keyItem];
            }
            
            NSUInteger len = [faces_array count];
            
            BOOL lastIsDelete = NO;
            for (int i = 0; i < len; i ++)
            {
                
                if(i == 20 || i == 40 || i == 60)
                {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    //            [deleteBtn setBackgroundImage:IMGGET(@"emoji_backspace.png") forState:UIControlStateHighlighted];
                    [deleteBtn setImage:IMGGET(@"emoji_backspace.png") forState:UIControlStateNormal];
                    
                    [deleteBtn addTarget:self action:@selector(deleteEmjoi) forControlEvents:UIControlEventTouchUpInside];
                    [self.nimEmojiScrollView addSubview:deleteBtn];
                    
                    if(i == len -1)
                    {
                        lastIsDelete = YES;
                    }
                }
                WUEmoticonsKeyboardKeyItem *keyItem = [faces_array objectAtIndex:i];
                
                RichButton *btn = [RichButton buttonWithType:UIButtonTypeCustom];
                btn.info = keyItem;
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 7);
                
                [btn setImage:keyItem.image forState:UIControlStateNormal];
                [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self.nimEmojiScrollView addSubview:btn];
                
            }
            
            
            if(lastIsDelete == NO)
            {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //            [deleteBtn setBackgroundImage:IMGGET(@"emoji_backspace.png") forState:UIControlStateHighlighted];
                [deleteBtn setImage:IMGGET(@"emoji_backspace.png") forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(deleteEmjoi) forControlEvents:UIControlEventTouchUpInside];
                [self.nimEmojiScrollView addSubview:deleteBtn];
                
            }
        }

        
        {
            NSDictionary    *bigFaces = [NIMQBLabel getBigFaceMap];
            NSMutableArray  *bigFaces_array = [[NSMutableArray alloc] initWithCapacity:bigFaces.count];
            
            
            for (NSString *value in bigFaces.allValues)
            {
                NSString *icon = [NIMQBLabel faceKeyForValue:value map:bigFaces];
                WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
//                NSString *url = [NSString stringWithFormat:@"m_%@",icon];
                NSString *url = [NSString stringWithFormat:@"%@.gif",icon];
                keyItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:url ofType:@""]];
                keyItem.textToInput = value;
                [bigFaces_array addObject:keyItem];
            }
            
            NSUInteger len = [bigFaces_array count];
            
            for (int i = 0; i < len; i ++)
            {
                
                WUEmoticonsKeyboardKeyItem *keyItem = [bigFaces_array objectAtIndex:i];
                
                RichButton *btn = [RichButton buttonWithType:UIButtonTypeCustom];
                btn.info = keyItem;
//                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, -15, 15);
                
                [btn setImage:keyItem.image forState:UIControlStateNormal];
               
                [btn addTarget:self action:@selector(bigClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.nimEmojiScrollView addSubview:btn];
                
            }
        }
        
        self.backgroundColor = [SSIMSpUtil getColor:@"f0f0f0"];
    }
    return self;
}

- (void)setCanUseBigFace:(BOOL)canUseBigFace
{
    _canUseBigFace = canUseBigFace;
    
    if(_canUseBigFace)
    {
        
    }
    else
    {
        
    }
}

- (void)click:(id)sender
{
    RichButton *button = (RichButton *)sender;
    
    if([_delegate respondsToSelector:@selector(emojiSelected:)])
    {
        [self.delegate emojiSelected:button.info];
    }
}

- (void)bigClick:(id)sender
{
    
    RichButton *button = (RichButton *)sender;
    
    if([_delegate respondsToSelector:@selector(bigEmojiSelected:)])
    {
        if([self addToHistoryBigEmoji:button])
        {
            [self.delegate bigEmojiSelected:button.info];
        }
    }
}

#define FACE_MIN_TIME               1

#define SAME_FACE_MAX_COUNT         3
#define SAME_FACE_MAX_COUNT_TIME    10
#define FACE_MAX_COUNT              6
#define FACE_MAX_COUNT_TIME         20
#define FACE_ERROR_TIP              @"您发送表情过于频繁，请稍候再发。"

- (BOOL)addToHistoryBigEmoji:(RichButton *)richButton
{
    
    if(self.historyBigEmoji == nil)
    {
        self.historyBigEmoji = @[].mutableCopy;
    }
    
    BigFaceClick *last = [self.historyBigEmoji lastObject];
    
    if(last)
    {
        NSTimeInterval timeInterval = [[NSDate date]timeIntervalSince1970] - last.faceTime;
        
        if(timeInterval < FACE_MIN_TIME)
        {
            // 每个表情之间发不能短于 FACE_MIN_TIME 秒
            
            [MBTip showTipsView:FACE_ERROR_TIP atView:self];
            return NO;
        }
        
    }
    else
    {
        //之前没有发送过大表情,这次可以随便发
        WUEmoticonsKeyboardKeyItem *item = (WUEmoticonsKeyboardKeyItem *)richButton.info;
        BigFaceClick *faceClick = [BigFaceClick bigFace:item.textToInput];
        
        [self.historyBigEmoji addObject:faceClick];
        return YES;
    }

    int length = [self.historyBigEmoji count];

    int sameCount = 0;
    
    NSTimeInterval timeInterval = NSTimeIntervalSince1970;
    
    NSString *lastText = nil;
    for (int i = length -1; i >= 0; i--)
    {
        BigFaceClick *click = [self.historyBigEmoji objectAtIndex:i];
        if(lastText == nil)
        {
            lastText = click.faceInfo;
            sameCount = 1;
            timeInterval= click.faceTime;
        }
        else
        {
            if([click.faceInfo isEqualToString:lastText])
            {
                sameCount++;
                timeInterval= click.faceTime;
            }
        }
    }
    
    
    NSTimeInterval sameTimeDun =  [[NSDate date]timeIntervalSince1970] - timeInterval;
    
    // 如果连续 发送 同一表情 SAME_FACE_MAX_COUNT 次 则 SAME_FACE_MAX_COUNT_TIME 秒后可再发
    
    if(sameCount >= SAME_FACE_MAX_COUNT  && (sameTimeDun - SAME_FACE_MAX_COUNT_TIME ) < 0 )
    {
        [MBTip showTipsView:FACE_ERROR_TIP atView:self];
        return NO;
    }
    
    
    // 如果连续 发送 表情 FACE_MAX_COUNT 次 则 FACE_MAX_COUNT_TIME 秒后可再发
    
    BigFaceClick *click = [self.historyBigEmoji objectAtIndex:0];
    
    timeInterval= click.faceTime;
    
    sameTimeDun =  [[NSDate date]timeIntervalSince1970] - timeInterval;
    
    if(sameCount >= FACE_MAX_COUNT  && (sameTimeDun - FACE_MAX_COUNT_TIME ) < 0 )
    {
        [MBTip showTipsView:FACE_ERROR_TIP atView:self];
        return NO;
    }
    
    if(length >= FACE_MAX_COUNT)
    {
       
        [self.historyBigEmoji removeObjectAtIndex:0];
    }

        WUEmoticonsKeyboardKeyItem *item = (WUEmoticonsKeyboardKeyItem *)richButton.info;
        
        BigFaceClick *faceClick = [BigFaceClick bigFace:item.textToInput];
        
        [self.historyBigEmoji addObject:faceClick];
    
    return YES;
}



- (void)deleteEmjoi
{
    if([_delegate respondsToSelector:@selector(deleteEmjoi)])
    {
        [self.delegate deleteEmjoi];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalW = 0;
    NSDictionary    *bigFaces = [NIMQBLabel getBigFaceMap];
    
    {
        CGFloat width = self.bounds.size.width;
        
        const NSInteger c = 7;
        CGFloat w = width/c;
        CGRect rt = CGRectZero;
        CGFloat h = 30;
        rt.size = CGSizeMake(w, h);
        
        self.nimEmojiScrollView.frame = CGRectMake(0, 10, width, 150);
        
        NSArray *sv = [self.nimEmojiScrollView subviews];
        NSInteger i = 0;
        NSInteger j = 0;
        NSInteger page = 0;
        
        NSInteger offY = 18;
        NSUInteger len = [sv count] - bigFaces.count;
        for (int kI = 0; kI < len; kI ++)
        {
            UIButton *btn = [sv objectAtIndex:kI];
            btn.frame = rt;
            
            if(kI < len - 1)
            {
                rt.origin.x += w;
                if (++i == c)
                {
                    j += 1;
                    
                    if (j == 3)
                    {
                        page += 1;
                        j = 0;
                        rt.origin.y = -h - offY;
                    }
                    rt.origin.x = page*CGRectGetWidth(self.bounds);
                    rt.origin.y += h + offY;
                    i = 0;
                }
            }
        }
        //self.qqEmojiScrollView.contentSize = CGSizeMake((page+1)*w*c, 150);
        self.qqEmojiPageControl.frame = CGRectMake(0, 150, CGRectGetWidth(self.bounds), 20);
        self.qqEmojiPageControl.numberOfPages = page+1;
        self.emojiBtnLeft.frame     = _CGR(0, CGRectGetHeight(self.bounds) - 45 , 130, 45);
        self.emojiBtnRight.frame    = _CGR(129, CGRectGetHeight(self.bounds) - 45, 130, 45);
        self.sendBtn.frame          = _CGR(258, CGRectGetHeight(self.bounds) - 45, CGRectGetWidth(self.bounds) - 258, 45);
        totalW = (page+1)*w*c;
    }

    {
        CGFloat width = self.bounds.size.width;
        
        const NSInteger c = 4;
        CGFloat w = width/c;
        CGRect rt = CGRectZero;
        CGFloat h = 50;
        rt.origin.x = totalW;
        rt.size = CGSizeMake(w, h);
        CGFloat margin = (w-50)/2-10;
        //self.qbEmojiScrollView.frame = CGRectMake(0, 20, width, 180);
        
        NSArray *sv = [self.nimEmojiScrollView subviews];
        NSInteger i = 0;
        NSInteger j = 0;
        NSInteger page = 0;
        
        NSInteger offY = 20;
        NSUInteger len = bigFaces.count;
        for (int kI = 0; kI < len; kI ++)
        {
            UIButton *btn = [sv objectAtIndex:kI+(sv.count-len)];
    
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, margin, -20, margin);

            btn.frame = rt;
            
            if(kI < len - 1)
            {
                rt.origin.x += w;
                if (++i == c)
                {
                    j += 1;
                    
                    if (j == 2)
                    {
                        page += 1;
                        j = 0;
                        rt.origin.y = -h - offY;
                    }
                    rt.origin.x = page*CGRectGetWidth(self.bounds)+totalW;
                    rt.origin.y += h + offY;
                    i = 0;
                }
            }
            
            
            
        }
        
        //self.qbEmojiScrollView.contentSize = CGSizeMake((page+1)*w*c, 160);
        //
        self.qbEmojiPageControl.frame = CGRectMake(0, 150, CGRectGetWidth(self.bounds), 20);
        self.qbEmojiPageControl.numberOfPages = page+1;
        totalW += (page+1)*w*c;
    }
    self.nimEmojiScrollView.contentSize = CGSizeMake(totalW, 0);

}



- (void)changeEmojiLeft
{
    [_emojiBtnLeft setImage:IMGGET(@"icon_dialog_phiz_jc_highlight") forState:UIControlStateNormal];
    [_emojiBtnRight setImage:IMGGET(@"icon_dialog_phiz_yu") forState:UIControlStateNormal];
    
    self.emojiType= 0;
    CGFloat width = self.bounds.size.width;
    [self.nimEmojiScrollView setContentOffset:CGPointMake(_qqIndex*width, 0)];
    
    
}

- (void)changeEmojiRight
{
    [_emojiBtnRight setImage:IMGGET(@"icon_dialog_phiz_yu_highlight") forState:UIControlStateNormal];
    [_emojiBtnLeft setImage:IMGGET(@"icon_dialog_phiz_jc") forState:UIControlStateNormal];

    self.emojiType = 1;
    
    CGFloat width = self.bounds.size.width;
    int index = _qbIndex==0?2:_qbIndex;
    [self.nimEmojiScrollView setContentOffset:CGPointMake(index*width, 0)];
    
}

- (void)sendEmoji
{
    if([_delegate respondsToSelector:@selector(richSendAction)])
    {
        [_delegate richSendAction];
    }
}

- (void)setEmojiType:(int)emojiType
{
    switch (emojiType) {
        case 0:
        {
//            self.qqEmojiScrollView.hidden = NO;
//            self.qbEmojiScrollView.hidden = YES;
            
            self.qqEmojiPageControl.hidden = NO;
            self.qbEmojiPageControl.hidden = YES;
            
            [self.emojiBtnLeft setBackgroundColor:[SSIMSpUtil getColor:@"dcdcdc"]];
            [self.emojiBtnRight setBackgroundColor:[SSIMSpUtil getColor:@"f0f0f0"]];
        }
            break;
        case 1:
        {
            if(self.canUseBigFace)
            {
//                self.qqEmojiScrollView.hidden = YES;
//                self.qbEmojiScrollView.hidden = NO;
                
                self.qqEmojiPageControl.hidden = YES;
                self.qbEmojiPageControl.hidden = NO;
                
                [self.emojiBtnLeft setBackgroundColor:[SSIMSpUtil getColor:@"f0f0f0"]];
                [self.emojiBtnRight setBackgroundColor:[SSIMSpUtil getColor:@"dcdcdc"]];
            }
            else
            {
                [MBTip showTipsView:@"当前只支持默认表情" atView:self];
                [self setEmojiType:0];
                return;
            }
        }
            break;
        default:
            break;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"滑动：%f__%f",scrollView.contentOffset.x,scrollView.frame.size.width);
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    if (index>1) {
        _qbIndex = index;
        [self changeEmojiRight];
        self.qbEmojiPageControl.currentPage = index - 2;

    }else{
        //self.emojiType = 0;
        _qqIndex = index;
        [self changeEmojiLeft];
        self.qqEmojiPageControl.currentPage = index;
        
    }
    
    
    
//    if(scrollView == self.qqEmojiScrollView)
//    {
//        int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
//        
//        self.qqEmojiPageControl.currentPage = index;
//    }
//    else if(scrollView == self.qbEmojiScrollView)
//    {
//        int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
//        
//        self.qbEmojiPageControl.currentPage = index;
//    }
    
}


- (UIScrollView *)qqEmojiScrollView
{
    if(!_qqEmojiScrollView)
    {
        CGRect frame =  self.bounds;
        frame.size.height -= 45;
        _qqEmojiScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _qqEmojiScrollView.pagingEnabled = YES;
        _qqEmojiScrollView.backgroundColor = [SSIMSpUtil getColor:@"f0f0f0"];
        _qqEmojiScrollView.delegate = self;
        _qqEmojiScrollView.bounces = YES;
        _qqEmojiScrollView.alwaysBounceHorizontal = YES;
        _qqEmojiScrollView.showsHorizontalScrollIndicator = NO;
        _qqEmojiScrollView.showsVerticalScrollIndicator = NO;
        _qqEmojiScrollView.scrollsToTop = NO;
        
    }
    return _qqEmojiScrollView;
}

- (UIScrollView *)qbEmojiScrollView
{
    if(!_qbEmojiScrollView)
    {
        CGRect frame =  self.bounds;
        frame.size.height -= 45;
        _qbEmojiScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _qbEmojiScrollView.backgroundColor = [SSIMSpUtil getColor:@"f0f0f0"];
        _qbEmojiScrollView.pagingEnabled = YES;
        _qbEmojiScrollView.delegate = self;
        _qbEmojiScrollView.bounces = YES;
        _qbEmojiScrollView.alwaysBounceHorizontal = YES;
        _qbEmojiScrollView.showsHorizontalScrollIndicator = NO;
        _qbEmojiScrollView.showsVerticalScrollIndicator = NO;
        _qbEmojiScrollView.scrollsToTop = NO;
    }
    return _qbEmojiScrollView;
}

-(UIScrollView *)nimEmojiScrollView
{
    if(!_nimEmojiScrollView)
    {
        CGRect frame =  self.bounds;
        frame.size.height -= 45;
        _nimEmojiScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _nimEmojiScrollView.backgroundColor = [SSIMSpUtil getColor:@"f0f0f0"];
        _nimEmojiScrollView.pagingEnabled = YES;
        _nimEmojiScrollView.delegate = self;
        _nimEmojiScrollView.bounces = YES;
        _nimEmojiScrollView.alwaysBounceHorizontal = YES;
        _nimEmojiScrollView.showsHorizontalScrollIndicator = NO;
        _nimEmojiScrollView.showsVerticalScrollIndicator = NO;
        _nimEmojiScrollView.scrollsToTop = NO;
    }
    return _nimEmojiScrollView;
}

- (UIButton *)emojiBtnLeft
{
    if(!_emojiBtnLeft)
    {
        _emojiBtnLeft = [[UIButton alloc]initWithFrame:_CGR(0, CGRectGetHeight(self.bounds) - 45 , 130, 45)];
        [_emojiBtnLeft setBackgroundColor:[SSIMSpUtil getColor:@"dcdcdc"]];
        [_emojiBtnLeft setImage:IMGGET(@"icon_dialog_phiz_jc_highlight") forState:UIControlStateNormal];
        [_emojiBtnLeft addTarget:self action:@selector(changeEmojiLeft) forControlEvents:UIControlEventTouchUpInside];
        CALayer * downButtonLayer = [_emojiBtnLeft layer];
        _emojiBtnLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [downButtonLayer setMasksToBounds:YES];
        [downButtonLayer setCornerRadius:0];
        [downButtonLayer setBorderWidth:1.0];
        [downButtonLayer setBorderColor:[[SSIMSpUtil getColor:@"BBBBBB"] CGColor]];
        _emojiBtnLeft.exclusiveTouch = YES;
    }
    return _emojiBtnLeft;
}

- (UIButton *)emojiBtnRight
{
    if(!_emojiBtnRight)
    {
        _emojiBtnRight = [[UIButton alloc]initWithFrame:_CGR(130, CGRectGetHeight(self.bounds) - 45, 130, 45)];
        [_emojiBtnRight setBackgroundColor:[SSIMSpUtil getColor:@"f0f0f0"]];
        [_emojiBtnRight setImage:IMGGET(@"icon_dialog_phiz_yu") forState:UIControlStateNormal];
        [_emojiBtnRight addTarget:self action:@selector(changeEmojiRight) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtnRight.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _emojiBtnRight.exclusiveTouch = YES;
        CALayer * downButtonLayer = [_emojiBtnRight layer];
        [downButtonLayer setMasksToBounds:YES];
        [downButtonLayer setCornerRadius:0];
        [downButtonLayer setBorderWidth:1.0];
        [downButtonLayer setBorderColor:[[SSIMSpUtil getColor:@"BBBBBB"] CGColor]];
    }
    return _emojiBtnRight;
}

- (UIButton *)sendBtn
{
    if(!_sendBtn)
    {
        _sendBtn = [[UIButton alloc]initWithFrame:_CGR(258, CGRectGetHeight(self.bounds) - 45, 63, 45)];
        [_sendBtn setBackgroundColor:[SSIMSpUtil getColor:@"087dfe"]];
//        [_sendBtn setImage:IMGGET(@"emoji_btn2.png") forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendEmoji) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.exclusiveTouch = YES;
//        CALayer * downButtonLayer = [_sendBtn layer];
//        [downButtonLayer setMasksToBounds:YES];
//        [downButtonLayer setCornerRadius:0];
//        [downButtonLayer setBorderWidth:1.0];
//        [downButtonLayer setBorderColor:[[SSIMSpUtil getColor:@"BBBBBB"] CGColor]];
    }
    return _sendBtn;
}

- (UIPageControl *)qqEmojiPageControl
{
    if(!_qqEmojiPageControl)
    {
        _qqEmojiPageControl = [[UIPageControl alloc] init];
        _qqEmojiPageControl.currentPageIndicatorTintColor = [SSIMSpUtil getColor:@"ff3020"];
        _qqEmojiPageControl.pageIndicatorTintColor = [SSIMSpUtil getColor:@"dcdcdc"];
        _qqEmojiPageControl.userInteractionEnabled = NO;
    }
    return _qqEmojiPageControl;
}

- (UIPageControl *)qbEmojiPageControl
{
    if(!_qbEmojiPageControl)
    {
        _qbEmojiPageControl = [[UIPageControl alloc] init];
        _qbEmojiPageControl.currentPageIndicatorTintColor = [SSIMSpUtil getColor:@"ff3020"];
        _qbEmojiPageControl.pageIndicatorTintColor = [SSIMSpUtil getColor:@"dcdcdc"];
        _qbEmojiPageControl.userInteractionEnabled = NO;
    }
    return _qbEmojiPageControl;
}

@end
