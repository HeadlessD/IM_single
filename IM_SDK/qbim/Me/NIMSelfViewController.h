//
//  NIMSelfViewController.h
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//


#import "NIMViewController.h"

#import <UIKit/UIKit.h>

@interface NIMSelfViewController : NIMViewController

@property (nonatomic, assign) int64 userid;
@property (nonatomic, assign) int64_t groupid;
//@property (nonatomic, strong) NSString *feedSourceType;
@property (nonatomic, assign) SourceType feedSourceType;
@property (nonatomic, copy) NSString * searchContent;
@property (strong, nonatomic) VcardEntity * vcardEntity;
@property (strong, nonatomic) FDListEntity * fdlist;


@end
