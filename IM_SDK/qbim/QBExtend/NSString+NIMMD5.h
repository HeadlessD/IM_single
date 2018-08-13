//
//  NSString+NIMMD5.h
//  Qianbao
//
//  Created by Rain on 13-11-11.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NIMMD5)
// MD5 hash of the file on the filesystem specified by path
+ (NSString *) nim_stringWithMD5OfFile: (NSString *) path;
// The string's MD5 hash
- (NSString *) nim_MD5Hash;
- (BOOL)nim_isLessToString:(NSString *)aString;

@end
