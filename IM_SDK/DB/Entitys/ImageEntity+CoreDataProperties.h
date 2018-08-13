//
//  ImageEntity+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "ImageEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageEntity (CoreDataProperties)

+ (NSFetchRequest<ImageEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bigFile;
@property (nullable, nonatomic, copy) NSString *file;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *thumb;
@property (nullable, nonatomic, retain) NSObject *thumbnailImage;
@property (nullable, nonatomic, retain) NSObject *transientImage;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

@end

NS_ASSUME_NONNULL_END
