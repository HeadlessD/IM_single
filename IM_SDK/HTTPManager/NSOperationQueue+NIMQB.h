//
//  NSOperationQueue+NSOperationQueue_QB.h
//  QianbaoIM
//
//  Created by 孔祥波 on 14-8-22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (NSOperationQueue_NIMQB)
+(dispatch_queue_t)nim_findCurrentQueue;
+(dispatch_queue_t)nim_mainqueue;
@end
