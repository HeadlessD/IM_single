//
//  NIMFeedCell.m
//  QianbaoIM
//
//  Created by Yun on 14/9/17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedCell.h"
//#import "FeedEntity.h"

@implementation NIMFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setCellDataSource:(FeedEntity*)feedEntity{
//    [super setCellDataSource:feedEntity];
//    
//    
//    //if(self.firstLoad)
//    {
//        [self setHeaderViewLayout];
//        [self setBottomViewLayout];
//        self.firstLoad = YES;
//    }
//    [self setBaseViewLayout:feedEntity];
//    NSArray * images = feedEntity.imageEntity.allObjects;
//    NSInteger count = feedEntity.imageEntity.count;
//    if(images.count > 0)
//    {
//        NSMutableDictionary* muDic = @{}.mutableCopy;
//        [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            ImageFeedEntity* imgEngity = (ImageFeedEntity*)obj;
//            [muDic setValue:imgEngity.url forKey:[NSString stringWithFormat:@"%d",imgEngity.index]];
//        }];
//        NSArray* allKeys = muDic.allKeys;
//        count = [allKeys count];
//    }
//    [self setImagesViewLayout:count];
//    
//    [self setHeaderValue:feedEntity];
//    [self setImagesValue:feedEntity];
//    [self setBottomValue:feedEntity];
//}

@end
