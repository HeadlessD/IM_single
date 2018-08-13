//
//  VideoEntity+CoreDataProperties.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/31.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "VideoEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VideoEntity (CoreDataProperties)

+ (NSFetchRequest<VideoEntity *> *)fetchRequest;

@property (nonatomic) int16_t duration;
@property (nullable, nonatomic, copy) NSString *file;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *thumb;
@property (nullable, nonatomic, copy) NSString *thumbUrl;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

@end

NS_ASSUME_NONNULL_END
