//
//  NIMBadgeView.h
//  QianbaoIM
//
//  Created by liunian on 14/9/17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMBadgeView : UIView
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, retain)   NSString *badgeString;
@property (nonatomic, assign)   UITableViewCell *parent;
@property (nonatomic, retain)   UIColor *badgeColor;
@property (nonatomic, retain)   UIColor *badgeColorHighlighted;
@property (nonatomic, assign)   BOOL showShadow;
@property (nonatomic, assign)   CGFloat radius;
@end
