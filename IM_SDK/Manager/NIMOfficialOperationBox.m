//
//  NIMOfficialOperationBox.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/5/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMOfficialOperationBox.h"

@interface NIMOfficialOperationBox()
@property(nonatomic,strong)NSMutableDictionary *offcialDict;

@end


@implementation NIMOfficialOperationBox

SingletonImplementation(NIMOfficialOperationBox)

-(void)addOffcialInfo:(NIMOffcialInfo *)info
{
    [NOffcialEntity instancetypeWithOffcialInfo:info];
}


@end
