//
//  NIMRedBagEntity+CoreDataProperties.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//
//

#import "NIMRedBagEntity+CoreDataProperties.h"

@implementation NIMRedBagEntity (CoreDataProperties)

+ (NSFetchRequest<NIMRedBagEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NIMRedBagEntity"];
}

@dynamic rb_openID;
@dynamic rb_sendName;
@dynamic rb_status;
@dynamic rb_openUrl;
@dynamic rb_wait;
@dynamic rb_type;
@dynamic rb_desc;
@dynamic rb_isGroup;
@dynamic rb_sendID;
@dynamic rb_messageID;
@dynamic rb_msgBodyId;

@end
