//
//  NIMFeedImgFlowLayout.h
//  QianbaoIM
//
//  Created by iln on 14/8/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMFeedImgFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger cellCount;
+ (CGSize)CollectionBubbleSizeWithCount:(NSInteger)count;
@end
