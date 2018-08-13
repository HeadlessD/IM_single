//
//  NSString+nimregular.m
//  QianbaoIM
//
//  Created by liyan on 14-4-2.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NSString+nimregular.h"
@implementation NSString (nimregular)

//NSArray *array = [@"[smiley][#微笑][/smiley][smiley]http://s1.dwstatic.com/group1/M00/33/77/073ab33a08b3f76b36219f297f2bc5c1.gif[/smiley]" regular:@"smiley"];
- (NSArray *)nim_regular:(NSString *)regulaStr
{
    NSError *error;
    NSMutableString *muRegulaStr = [NSMutableString stringWithFormat:@"\\[%@\\]",regulaStr];
    [muRegulaStr appendString:@"[a-zA-Z0-9%_\\/.:+\\-]+"];
    [muRegulaStr appendFormat:@"\\[/%@\\]",regulaStr];
    
    [muRegulaStr appendFormat:@"|\\[%@\\]",regulaStr];
    [muRegulaStr appendString:@"[#\\[\\]\u4e00-\u9fa5]+"];
    [muRegulaStr appendFormat:@"\\[/%@\\]",regulaStr];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:muRegulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableArray *array = @[].mutableCopy;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSRange range = match.range;
        
        range.location += 2 + regulaStr.length;
        range.length -= (2 + 3 + 2 * regulaStr.length);
        
        NSString* substringForMatch = [self substringWithRange:range];
        
        [array addObject:substringForMatch];
    }
    return array.copy;
}

+ (NSString *)nim_emojiDelete:(NSString *)emoji
{
    NSString *str = emoji;
    if([str length] <1)
    {
        return str;
    }
    
    
    if([str hasSuffix:@"]"])
    {

        NSError *error;
        NSString *muRegulaStr = [NSString stringWithFormat:@"\\[[\u4e00-\u9fa5]{1,3}\\]"];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:muRegulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        if([arrayOfAllMatches count]> 0 )
        {
            NSTextCheckingResult *match = [arrayOfAllMatches lastObject];
            NSRange range = match.range;
            
            str =  [str substringWithRange:NSMakeRange(0 , [str length] - range.length)];
        }

    }
    
    return  str;
}

@end
