//
//  NIMRedBagEntity+CoreDataProperties.h
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//
//

#import "NIMRedBagEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NIMRedBagEntity (CoreDataProperties)

+ (NSFetchRequest<NIMRedBagEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *rb_openID;
@property (nullable, nonatomic, copy) NSString *rb_sendName;
@property (nonatomic) int16_t rb_status;
@property (nullable, nonatomic, copy) NSString *rb_openUrl;
@property (nullable, nonatomic, copy) NSString *rb_wait;
@property (nullable, nonatomic, copy) NSString *rb_type;
@property (nullable, nonatomic, copy) NSString *rb_desc;
@property (nonatomic) BOOL rb_isGroup;
@property (nullable, nonatomic, copy) NSString *rb_sendID;
@property (nonatomic) int64_t rb_messageID;
@property (nullable, nonatomic, copy) NSString *rb_msgBodyId;

@end

NS_ASSUME_NONNULL_END
