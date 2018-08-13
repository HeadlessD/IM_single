//
//  NIMReportViewController.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/3/20.
//  Copyright (c) 2015年 xuqing. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMReportViewController : NIMViewController
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSIndexPath *lastPath;
@property (nonatomic, strong) NSString *reportType;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *reason_type;
@property (nonatomic, strong) NSString *reason_content;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *contView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *leathLable;
@property (nonatomic, strong) NSString *pushType;
@property (nonatomic, strong) NSString *linkurl;
@property (nonatomic, strong) NSString *tweeturl;
@property (nonatomic) BOOL isTweet;



@end
