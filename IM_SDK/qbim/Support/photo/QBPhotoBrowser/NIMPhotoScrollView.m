//
//  NIMPhotoScrollView.m
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  图片切换scrollview

#import "NIMPhotoScrollView.h"

@implementation NIMPhotoScrollView

- (void)setScrollDataSource:(NSArray*)photoObjects
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(NSInteger i=0;i<photoObjects.count;i++)
    {
        NIMPhotoObject* obj = [photoObjects objectAtIndex:i];
        NIMPhotoView* v = [[NIMPhotoView alloc] init];
        v.delegate = _VCDelegate;
        v.tag = i+1;
        v.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [v setPhotoViewDataSource:obj];
        [self addSubview:v];
    }
    [self setContentSize:CGSizeMake(photoObjects.count*self.frame.size.width, self.frame.size.height)];
}



@end
