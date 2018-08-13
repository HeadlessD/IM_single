//
//  AudioEntity+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "AudioEntity+CoreDataProperties.h"

@implementation AudioEntity (CoreDataProperties)

+ (NSFetchRequest<AudioEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AudioEntity"];
}

@dynamic duration;
@dynamic file;
@dynamic read;
@dynamic state;
@dynamic url;
@dynamic chatRecord;

@end
