//
//  TextEntity+CoreDataProperties.h
//  qbim
//
//  Created by 秦雨 on 17/2/15.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "TextEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TextEntity (CoreDataProperties)

+ (NSFetchRequest<TextEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, retain) ChatEntity *chatRecord;

@end

NS_ASSUME_NONNULL_END
