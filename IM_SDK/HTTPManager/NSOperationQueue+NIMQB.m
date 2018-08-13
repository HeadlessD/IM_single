//
//  NSOperationQueue+NSOperationQueue_QB.m
//  QianbaoIM
//
//  Created by 孔祥波 on 14-8-22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NSOperationQueue+NIMQB.h"

@implementation NSOperationQueue (NIMQB)
+(dispatch_queue_t)nim_findCurrentQueue
{
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_queue_t rqueue;
    if (currentQueue == dispatch_get_main_queue()) {
        dispatch_queue_t q= dispatch_queue_create("com.qbao.im", nil);
        rqueue = q;
    }else{
        rqueue = currentQueue;
    }
    return rqueue;
}
+(dispatch_queue_t)nim_mainqueue
{
    return dispatch_get_main_queue();
}
@end
