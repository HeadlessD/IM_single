//
//  NIMSampleQueueId.h
//  ExampleApp
//
//  Created by Thong Nguyen on 20/01/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatEntity;

@interface NIMSampleQueueId : NSObject
@property (readwrite) ChatEntity *recordEntity;
- (id)initWithChatEntity:(ChatEntity *)recordEntity;
@end
