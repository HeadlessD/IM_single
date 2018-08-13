//
//  NIMMessageContent.m
//  QBIM
//
//  Created by liunian on 14-3-17.
//  Copyright (c) 2014年 liunian. All rights reserved.
//

#import "NIMMessageContent.h"
  


@interface NIMMessageContent ()
@end

@implementation NIMMessageContent

+ (NSString *)combineThreadWithE_MSG_CHAT_TYPE:(E_MSG_CHAT_TYPE)MT fromID:(double)fromid toID:(double)toid{
    NSMutableString *thredString = [[NSMutableString alloc] init];

    if (fromid<=10) {
        DBLog(@"出现问题啦");
    }
    //masterId
    [thredString appendFormat:@"%ld",(long)MT];
    if (MT == SYS || MT == PUBLIC) {
        [thredString appendFormat:@":%.0f", fromid];
    }else if(MT == GROUP) {
        [thredString appendFormat:@":%.0f",fromid];

    }else if(MT == PRIVATE) {
        [thredString appendFormat:@":%.0f",fromid< toid ? fromid : toid];
    }

    //slaveId
    if (MT == SYS || MT == PUBLIC) {
//        [thredString appendString:@":0"];
         [thredString appendFormat:@":%.0f",toid];
    }else if(MT == GROUP) {
        [thredString appendString:@":0"];

    }else if(MT == PRIVATE) {
        [thredString appendFormat:@":%.0f",fromid > toid? fromid : toid];
        
    }
    return thredString;
}


+ (double)captureGroupidWithThread:(NSString *)thread{
    NSArray *array = [thread componentsSeparatedByString:@":"];
    if(array.count >1){
        return [[array objectAtIndex:1] doubleValue];
    }
    return 0;
}

+ (double)getPrivateReceiveIdWithThread:(NSString*)thread
{
    NSArray *nums = [thread componentsSeparatedByString:@":"];
    double receiveId=0;

    double mid = [[nums objectAtIndex:1] doubleValue];
    double lastid = [[nums objectAtIndex:2] doubleValue];
    if (mid != OWNERID) {
        receiveId = mid;
    }else{
        receiveId = lastid;
    }
    
    return receiveId;
}

+ (double)getPrivateSenderIdWithThread:(NSString*)thread
{
    NSArray *nums = [thread componentsSeparatedByString:@":"];
    double senderid = 0;

    double mid = [[nums objectAtIndex:1] doubleValue];
    double lastid = [[nums objectAtIndex:2] doubleValue];
    if (mid == OWNERID) {
        senderid = mid;
    }else{
        senderid = lastid;
    }

    return senderid;
}

+ (E_MSG_CHAT_TYPE)chatTypeWithThread:(NSString *)thread{
    NSArray *array = [thread componentsSeparatedByString:@":"];
    if(array.count >0){
        return [[array objectAtIndex:0] integerValue];
    }
    return 0;
}

@end
