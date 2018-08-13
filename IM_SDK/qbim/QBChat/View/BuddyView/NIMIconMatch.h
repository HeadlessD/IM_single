//
//  NIMIconMatch.h
//  QianbaoIM
//
//  Created by liu nian on 14-3-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BEGIN_TAG @"["
#define BEGINBIG_TAG @"[#"
#define END_TAG  @"]"

@interface NIMIconMatch : NSObject
{
    NSMutableArray * _strs;
    NSMutableArray * _bigs;
}

- (NSArray*)Match:(NSString *)resource;
- (NSArray*)MatchBig:(NSString *)resource;
@end
