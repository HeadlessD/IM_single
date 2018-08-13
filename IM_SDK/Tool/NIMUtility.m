//
//  NIMUtility.m
//  QBSDK
//
//  Created by liu nian on 14-4-23.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import "NIMUtility.h"
#import "zlib.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NIMUtility

//TODO:JSON
+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NIMUtility jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
//    NSArray *keys = [dictionary allKeys];
//    NSMutableString *reString = [NSMutableString string];
//    [reString appendString:@"{"];
//    NSMutableArray *keyValues = [NSMutableArray array];
//    for (int i=0; i<[keys count]; i++) {
//        NSString *name = [keys objectAtIndex:i];
//        id valueObj = [dictionary objectForKey:name];
//        NSString *value = [NIMUtility jsonStringWithObject:valueObj];
//        if (value) {
//            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
//        }
//    }
//    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
//    [reString appendString:@"}"];
//    return reString;
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSString *) stringWithDictionary:(NSDictionary *)dictionary{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSString *) jsonStringWithNSNumber:(NSNumber *)number{
    return [NSString stringWithFormat:@"%.0f",[number doubleValue]];
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NIMUtility jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NIMUtility jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NIMUtility jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSNumber class]]){
        value = [NIMUtility jsonStringWithNSNumber:object];
    }
    return value;
}

+(NSString *) getSelectorNameByPacketType:(NSInteger) type{
    
    NIMUtility *utility = [[NIMUtility alloc] init];
    
    NSString *name =  [utility.selDict objectForKey:@(type)];
    
    return name;
}

+ (NSDictionary *)jsonWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    return dic;
}

@end
