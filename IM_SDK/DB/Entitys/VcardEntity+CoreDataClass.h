//
//  VcardEntity+CoreDataClass.h
//  QBNIMClient
//
//  Created by 豆凯强 on 17/6/29.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatEntity, FDListEntity, GMember, PhoneBookEntity;

NS_ASSUME_NONNULL_BEGIN

@interface VcardEntity : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "VcardEntity+CoreDataProperties.h"
