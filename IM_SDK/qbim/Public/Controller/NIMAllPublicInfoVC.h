//
//  NIMAllPublicInfoVC.h
//  QianbaoIM
//
//  Created by qianwang on 15/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMAllPublicInfoVC : NIMViewController
@property (nonatomic, assign) double publicid;
//@property (nonatomic, strong) NSString * sourceType;
@property (nonatomic, assign) NSInteger publicSourceType;
@property (nonatomic,strong) NSIndexPath *m_indexPath;
@end
