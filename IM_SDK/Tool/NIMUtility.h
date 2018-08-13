//
//  NIMUtility.h
//  QBSDK
//
//  Created by liu nian on 14-4-23.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMUtility : NSObject
@property(nonatomic,strong)NSDictionary *selDict;

+(NSString *) getSelectorNameByPacketType:(NSInteger) type;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) stringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithObject:(id) object;
+(NSDictionary *)jsonWithJsonString:(NSString *)jsonString;
@end
