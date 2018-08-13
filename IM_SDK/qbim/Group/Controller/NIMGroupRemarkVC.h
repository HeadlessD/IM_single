//
//  NIMGroupRemarkVC.h
//  qbim
//
//  Created by 秦雨 on 17/4/27.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMViewController.h"
#import "RemarkEntity+CoreDataClass.h"

@interface NIMGroupRemarkVC : NIMViewController
@property(nonatomic,strong)RemarkEntity *remarkEntity;
@property(nonatomic,assign)int64_t groupid;
@property(nonatomic,assign)BOOL isLeader;
@property(nonatomic,strong)NSString *remark;

@end
