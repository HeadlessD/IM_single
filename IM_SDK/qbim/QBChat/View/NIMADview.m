//
//  NIMADview.m
//  QianbaoIM
//
//  Created by xuqing on 16/3/24.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMADview.h"
#import "NIMAdModel.h"
@implementation NIMADview
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _adArray =[[NSMutableArray alloc]initWithCapacity:0];
       
        self.firstTime =YES;
        NSArray *array =@[@{@"backColor":@"ffefef",@"lableColor":@"b82e1b"},@{@"backColor":@"e5f5f6",@"lableColor":@"1b95b8"},@{@"backColor":@"fdeed7",@"lableColor":@"b85d1b"}];
        _ColorArray =[[NSMutableArray alloc]initWithArray:array];
        
        [self loaddata];
         [self autoLayOut];
        
      
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail:)];
        
        [self addGestureRecognizer:tapGesture];
        
        
        

    }
    return self;
}
-(void)detail:(id)tap
{
    NIMAdModel *mod =[self.adArray lastObject];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(AdDeatil:)]) {
        [self.delegate AdDeatil:mod.adUrl];
    }
}
-(void)beganAmnion:(NSTimer*)time
{

    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 1.1f;
    
    //设置运动type
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [self.layer addAnimation:animation forKey:@"animation"];
//    [UIView beginAnimations:@"View Filp" context:nil];
//    [UIView setAnimationDelay:0.25];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
//    [UIView commitAnimations];
    
    [self updateView];
 
}
-(void)dealloc
{
    [_timer invalidate];
}
-(void)loaddata
{
    
}
-(void)updateView
{
 
    NIMAdModel *mod =(NIMAdModel*)[self.adArray firstObject];
    self.tipLable.text =mod.adtitle;
    NSString *textcolor =[self.ColorArray firstObject][@"lableColor"];
    NSString *viewColor =[self.ColorArray firstObject][@"backColor"];
    self.tipLable.textColor =[SSIMSpUtil getColor:textcolor];
    self.backgroundColor=[SSIMSpUtil getColor:viewColor];
    
    [self.adArray insertObject:self.adArray[0] atIndex:self.adArray.count];
    [self.adArray removeObjectAtIndex:0];

    [self.ColorArray insertObject:self.ColorArray[0] atIndex:self.ColorArray.count];
    [self.ColorArray removeObjectAtIndex:0];
   
   
}
-(void)autoLayOut
{
    [self.tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-50));
        make.height.equalTo(@30);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@30);

    }];
    self.hidden=YES;
}
-(void)cancleBtnPressed:(id)sender
{
    [self.timer invalidate];
    [self removeFromSuperview];
}
-(UILabel*)tipLable
{
    if (!_tipLable) {
        _tipLable =[[UILabel alloc]init];
        _tipLable.backgroundColor =[UIColor clearColor];
        _tipLable.lineBreakMode = NSLineBreakByTruncatingTail;
        _tipLable.font=[UIFont systemFontOfSize:16];
        [self addSubview:_tipLable];
    }
    return _tipLable;
}
-(UIButton*)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn =[[UIButton alloc]init];
        [_cancleBtn setImage:IMGGET(@"x") forState:UIControlStateNormal];
        [_cancleBtn setBackgroundColor:[UIColor clearColor]];
        [_cancleBtn addTarget:self action:@selector(cancleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBtn];
    }
    return _cancleBtn;
}
@end
