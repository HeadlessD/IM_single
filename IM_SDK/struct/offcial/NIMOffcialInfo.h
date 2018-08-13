//
//  NIMOffcialInfo.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/6/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMOffcialInfo : NSObject
@property(nonatomic,assign)int64_t offcialid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *avatar;

-(instancetype)initWithOffcialid:(int64_t)offcial name:(NSString *)name avatar:(NSString *)avatar;

@end
