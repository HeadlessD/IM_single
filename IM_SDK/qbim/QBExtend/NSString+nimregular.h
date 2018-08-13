//
//  NSString+nimregular.h
//  QianbaoIM
//
//  Created by liyan on 14-4-2.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (nimregular)

//NSString *string = @"xx[img]http://www.baidu.com/111.png[/img]dsadxZxsad[img]bb[/img][img]cc[/img]";
//[string regular:@"img"];
- (NSArray *)nim_regular:(NSString *)regulaStr;

+ (NSString *)nim_emojiDelete:(NSString *)emoji;

@end
