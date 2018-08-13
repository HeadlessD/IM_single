//
//  NIMTextAttachment.m
//  QianbaoIM
//
//  Created by iln on 14/8/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMTextAttachment.h"

@implementation NIMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 2 , -3 , lineFrag.size.height - 2 , lineFrag.size.height - 2);
}
@end
