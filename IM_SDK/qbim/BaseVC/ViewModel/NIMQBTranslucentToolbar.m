//
//  NIMQBTranslucentToolbar.m
//  QianbaoIM
//
//  Created by liyan on 10/13/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMQBTranslucentToolbar.h"

@implementation NIMQBTranslucentToolbar


- (void)drawRect:(CGRect)rect {
    // do nothing
}

- (id)initWithFrame:(CGRect)aRect {
    if ((self = [super initWithFrame:aRect])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

@end
