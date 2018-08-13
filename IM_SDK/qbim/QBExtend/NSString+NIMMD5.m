//
//  NSString+NIMMD5.m
//  Qianbao
//
//  Created by Rain on 13-11-11.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import "NSString+NIMMD5.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (NIMMD5)
+ (NSString *) nim_stringWithMD5OfFile: (NSString *) path {
    
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
	if (handle == nil) {
		return nil;
	}
	
	CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
	
	BOOL done = NO;
	
	while (!done) {
        
		NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
		CC_MD5_Update (&md5, [fileData bytes], [fileData length]);
		
		if ([fileData length] == 0) {
			done = YES;
		}
		
        fileData;
		
	}
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final (digest, &md5);
	NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0],  digest[1],
				   digest[2],  digest[3],
				   digest[4],  digest[5],
				   digest[6],  digest[7],
				   digest[8],  digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
    
	return s;
	
}

- (NSString *) nim_MD5Hash {
	
	CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
	CC_MD5_Update (&md5, [self UTF8String], strlen([self UTF8String]));
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final (digest, &md5);
	NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0],  digest[1],
				   digest[2],  digest[3],
				   digest[4],  digest[5],
				   digest[6],  digest[7],
				   digest[8],  digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
    
	return s;
	
}



- (BOOL)nim_isLessToString:(NSString *)aString
{
    NSArray * preVerAry = [self componentsSeparatedByString:@"."];
    NSArray * verAry = [aString componentsSeparatedByString:@"."];
    
    // 分段比较版本值
    for (int i = 0; i < [preVerAry count] || i < [verAry count]; i++) {
        int prSubVer, subVer;
        // 如果子版本号数不足，作为0处理
        if (i >= [preVerAry count]) {
            prSubVer = 0;
        } else {
            prSubVer = [[preVerAry objectAtIndex:i] intValue];
        }
        
        if (i >= [verAry count]) {
            subVer = 0;
        } else {
            subVer = [[verAry objectAtIndex:i] intValue];
        }
        
        if (prSubVer > subVer) {
            return NO;
        } else if (prSubVer < subVer) {
            return YES;
        }
    }
    return NO;
    
}
@end
