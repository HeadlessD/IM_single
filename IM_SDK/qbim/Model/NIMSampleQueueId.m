//
//  NIMSampleQueueId.m
//  ExampleApp
//
//  Created by Thong Nguyen on 20/01/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import "NIMSampleQueueId.h"
#import "ChatEntity+CoreDataClass.h"

@implementation NIMSampleQueueId

- (id)initWithChatEntity:(ChatEntity *)recordEntity;
{
    if (self = [super init])
    {
        self.recordEntity = recordEntity;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [NIMSampleQueueId class])
    {
        return NO;
    }
    NSTimeInterval timestamp = self.recordEntity.ct;
    NIMSampleQueueId *object_NIMSampleQueueId = (NIMSampleQueueId *)object;
    NSTimeInterval object_timestamp = object_NIMSampleQueueId.recordEntity.ct;
    return (timestamp - object_timestamp) ? NO : YES;
}

- (NSString*) description
{
    return [[NSDate dateWithTimeIntervalSince1970:self.recordEntity.ct] description];
}

@end
