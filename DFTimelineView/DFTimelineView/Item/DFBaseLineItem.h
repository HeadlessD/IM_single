//
//  DFBaseLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


@interface DFBaseLineItem : NSObject

//时间轴itemID 需要全局唯一 一般服务器下发
@property (nonatomic, assign) int64_t itemId;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) Moments_Content_Type contentType;


@property (nonatomic, assign) int64_t userId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) int64_t ts;


@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *comments;


@property (nonatomic, strong) NSMutableAttributedString *likesStr;

@property (nonatomic, strong) NSMutableArray *commentStrArray;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) Moments_Priv_Type priType;

@property (nonatomic, strong) NSString *whiteList;

@property (nonatomic, strong) NSString *blackList;

@property (nonatomic, assign) BOOL isRefresh;

@end
