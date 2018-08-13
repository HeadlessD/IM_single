//
//  ImageEntity+CoreDataProperties.m
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "ImageEntity+CoreDataProperties.h"

@implementation ImageEntity (CoreDataProperties)

+ (NSFetchRequest<ImageEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ImageEntity"];
}

@dynamic bigFile;
@dynamic file;
@dynamic img;
@dynamic thumb;
@dynamic thumbnailImage;
@dynamic transientImage;
@dynamic chatRecord;

@end
