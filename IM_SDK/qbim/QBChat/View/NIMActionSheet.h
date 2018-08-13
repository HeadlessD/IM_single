//
//  NIMActionSheet.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/19.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

//Blocks

typedef void(^SeletedButtonIndex)(NSInteger Buttonindex);

typedef void(^CompleteAnimationBlock)(BOOL Complete);

@interface NIMActionSheet : UIView

@property (nonatomic,strong)    SeletedButtonIndex ButtonIndex;

-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray<NSString *> *)Titles AttachTitle:(NSString *)AttachTitle;

-(void)ButtonIndex:(SeletedButtonIndex)ButtonIndex;

-(void) ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index;

-(void) SelectImageAndIndex:(NSInteger )index;

-(void)show;
@end
