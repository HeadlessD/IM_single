//
//  NIMPopBaseContextView.m
//  QianbaoIM
//
//  Created by liyan on 9/23/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMPopBaseContextView.h"

@implementation NIMPopBaseContextView

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(0,@"Use `initWithHeight:`");
    return nil;
}

- (id)initWithHeight:(CGFloat)height
{
    self = [super initWithFrame:_CGR(0, 0, 0, height)];
    if(self)
    {
        self.backgroundColor = _COLOR_WHITE;
    }
    return self;
}


- (void)updateUIWithModel:(id)data
{
    self.model = data;
}

- (void)show
{
    
}
@end
