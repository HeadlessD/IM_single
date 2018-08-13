//
//  NIMPhotoScrollView.h
//  QianbaoIM
//
//  Created by Yun on 14/9/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPhotoObject.h"
#import "NIMPhotoView.h"
@interface NIMPhotoScrollView : UIScrollView
- (void)setScrollDataSource:(NSArray*)photoObjects;
@property (nonatomic, assign) id VCDelegate;
@end
