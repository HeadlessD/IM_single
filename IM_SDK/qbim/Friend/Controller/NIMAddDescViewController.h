//
//  NIMAddDescViewController.h
//  QianbaoIM
//
//  Created by xuguochen on 15/12/28.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMAddDescViewController : NIMViewController

@property (nonatomic, assign) int64_t   userId;
@property (nonatomic, assign) NSInteger   addSourceType;
//@property (nonatomic, strong) NSString * addSourceType;
@property (nonatomic,copy) void(^addBackRefesh)();


@end
