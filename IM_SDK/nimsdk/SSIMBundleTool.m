//
//  SSIMBundleTool.m
//  testSDK1
//
//  Created by 秦雨 on 17/5/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMBundleTool.h"

@implementation SSIMBundleTool
+ (NSBundle *)getBundle {
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"NIMResource" ofType: @"bundle"]];
}
@end
