//
//  NIMLoginHistoryCell.m
//  QianbaoIM
//
//  Created by xuqing on 16/3/3.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMLoginHistoryCell.h"
#import "NIMAccountsInfo.h"
#import "NIMAccountsManager.h"
@implementation NIMLoginHistoryCell
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)setAutoLayOut:(NSArray*)array
{
    for(UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
       self.acountArray = [[NSMutableArray alloc] initWithArray:array];
   
       for (int i=0; i<array.count; i++) {
        UIImageView *_iconImage =[[UIImageView alloc]init];
        NIMAccountsInfo *modle =[array objectAtIndex:i];
        _iconImage.backgroundColor=[UIColor clearColor];
         _iconImage.userInteractionEnabled=YES;
        _iconImage.tag =100+i;
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:modle.avatar] placeholderImage:[UIImage imageNamed:@"icon_point_head.png"]];
        [self.contentView addSubview:_iconImage];
        
        _iconImage.frame= CGRectMake(((SCREEN_WIDTH -60*(array.count))/(array.count+1))*(i+1)+60*i,15,50,50);
        _iconImage.layer.cornerRadius =25;
       
        _iconImage.layer.masksToBounds=YES;

        //创建一个tap事件
           UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
           tap.numberOfTouchesRequired = 1; //手指数
           tap.numberOfTapsRequired = 1; //tap次数
           [_iconImage addGestureRecognizer:tap];
           
           
           
        //创建长按手势监听
        UILongPressGestureRecognizer *_longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(myHandleTableviewCellLongPressed:)];
        _longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [self.contentView addGestureRecognizer:_longPress];
    }
    
    
}
-(void)tapImage:(UITapGestureRecognizer*)tapGestureRecognizer
{
    UIImageView *image = (UIImageView *)tapGestureRecognizer.view;
    NIMAccountsInfo *model =[self.acountArray objectAtIndex:(image.tag-100)];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(selectAccount:)])
    {
        [self.delegate selectAccount:model];
    }
    NSLog(@"tap,hahahha：%ld",(long)image.tag);

}
- (void)myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIView *btn = (UIView *)gestureRecognizer.view;
        
        btn.userInteractionEnabled=YES;
        for (UIView *view in btn.subviews ) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
       

        for (UIImageView *image in btn.subviews) {
            image.userInteractionEnabled=NO;
            UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
            dele.tag =image.tag;
            [dele setImage:IMGGET(@"deleteBtn") forState:UIControlStateNormal];
            [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
            dele.backgroundColor=[UIColor clearColor];
            
            [image.superview addSubview:dele];
            
            [dele mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(image.mas_top);
                make.width.equalTo(@15);
                make.height.equalTo(@15);
                make.leading.equalTo(image.mas_trailing).with.offset(-5);
            }];

        }
       
    }
}
-(void)deletePic:(id)sender
{
    UIButton *btn =(UIButton*)sender;
    [self.acountArray removeObjectAtIndex:(btn.tag-100)];
    
    NIMAccountsInfo *info = [[[NIMAccountsManager shareIntance] getLocalAccounts] objectAtIndex:(btn.tag-100)];
    [[NIMAccountsManager shareIntance] deleteLocalByAccountsInfo:info];
 
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteLocalAccounts:)]) {
        [self.delegate deleteLocalAccounts:self.acountArray];
    }
}
-(void)deleteAcount:(id)sender
{
    
}
@end
