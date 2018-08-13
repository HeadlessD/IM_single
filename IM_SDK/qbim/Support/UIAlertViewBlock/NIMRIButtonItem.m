//
//  NIMRIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "NIMRIButtonItem.h"

@implementation NIMRIButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [[self alloc] init];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    NIMRIButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    
    return newItem;
}

+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action
{
  NIMRIButtonItem *newItem = [self itemWithLabel:inLabel];
  [newItem setAction:action];
  return newItem;
}

@end

