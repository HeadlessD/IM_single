//
//  NIMMenuView.h
//  QianbaoIM
//
//  Created by Rain on 14-9-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMMenuViewCell.h"

@protocol NIMMenuViewDelegate <NSObject>

- (void)selectIndex:(NSInteger)index;

@end

@interface NIMMenuView : UIView

@property (nonatomic,weak) id<NIMMenuViewDelegate> delegate;

- (id)initWithSourse:(NSArray *)dataSource andCell:(Class)cell;
@end
