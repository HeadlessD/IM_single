//
//  DFBaseUserLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


@interface DFBaseUserLineItem : NSObject

@property (nonatomic, assign) int64_t itemId;

@property (nonatomic, assign) int64_t ts;

@property (nonatomic, assign) NSUInteger year;

@property (nonatomic, assign) NSUInteger month;

@property (nonatomic, assign) NSUInteger day;

@property (nonatomic, assign) BOOL bShowTime;

@end
