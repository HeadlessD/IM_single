//
//  NIMIconMatch.m
//  QianbaoIM
//
//  Created by liu nian on 14-3-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMIconMatch.h"

@implementation NIMIconMatch

#pragma -mark 初始化方法
-(id)init
{
    self =[super init];
    if(self){
        _strs = [NSMutableArray array];
        _bigs = @[].mutableCopy;
    }
    return self;
}

#pragma -mark 私有方法
-(void)match:(NSString*) resource
{
    if(resource.length==0)
        return;
    NSRange end=[resource rangeOfString:END_TAG];
    if(end.location==NSNotFound)
        {
        [_strs addObject:resource];
        return;
        }else
            {
            NSString * string=[resource substringToIndex:end.location];
            if(string==nil)
                {
                [_strs addObject:resource];
                return;
                }else
                    {
                    NSRange begin=[string rangeOfString:BEGIN_TAG options:NSBackwardsSearch];
                    if(begin.location==NSNotFound)
                        {
                        [_strs addObject:resource];
                        return;
                        }else{
                            string=[string substringToIndex:begin.location];
                            if([string length]>0){
                                [_strs addObject:string];
                            }
                            [_strs addObject:[resource substringWithRange:NSMakeRange(begin.location, end.location-begin.location+1)]];
                            [self match:[resource substringFromIndex:end.location+1]];
                        }
                    }
            }    
}

- (NSArray*)Match:(NSString*)resource
{
    [self match:resource];
    return _strs;
}

- (void)matchBig:(NSString *)resource{
    if(resource.length == 0)
        return;

    NSRange end=[resource rangeOfString:END_TAG];
    if(end.location==NSNotFound)
        {
        [_bigs addObject:resource];
        return;
        }else
            {
            NSString * string=[resource substringToIndex:end.location];
            if(string==nil)
                {
                [_bigs addObject:resource];
                return;
                }else
                    {
                    NSRange begin=[string rangeOfString:BEGINBIG_TAG options:NSBackwardsSearch];
                    if(begin.location==NSNotFound)
                        {
                        [_bigs addObject:resource];
                        return;
                        }else{
                            string=[string substringToIndex:begin.location];
                            if([string length]>0){
                                [_bigs addObject:string];
                            }
                            [_bigs addObject:[resource substringWithRange:NSMakeRange(begin.location, end.location-begin.location+1)]];
                            [self MatchBig:[resource substringFromIndex:end.location+1]];
                        }
                    }
            }

}
- (NSArray *)MatchBig:(NSString *)resource{
    [self matchBig:resource];
    return _bigs;
}
@end
