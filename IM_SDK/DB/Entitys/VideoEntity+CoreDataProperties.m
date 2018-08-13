//
//  VideoEntity+CoreDataProperties.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/31.
//  Copyright © 2018年 豆凯强. All rights reserved.
//
//

#import "VideoEntity+CoreDataProperties.h"

@implementation VideoEntity (CoreDataProperties)

+ (NSFetchRequest<VideoEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VideoEntity"];
}

@dynamic duration;
@dynamic file;
@dynamic url;
@dynamic thumb;
@dynamic thumbUrl;
@dynamic chatRecord;

@end
