//
//  AudioEntity+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "AudioEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AudioEntity (CoreDataProperties)

+ (NSFetchRequest<AudioEntity *> *)fetchRequest;

@property (nonatomic) int16_t duration;
@property (nullable, nonatomic, copy) NSString *file;
@property (nonatomic) BOOL read;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

@end

NS_ASSUME_NONNULL_END
