//
//  NIMModifyUserInfoParm.h
//  QianbaoIM
//
//  Created by liyan on 10/8/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMBaseParmModel.h"

@interface NIMModifyUserInfoParm : NIMBaseParmModel

_PROPERTY_NONATOMIC_RETAIN(NSString, qb_nickName);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_sex);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthday);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_locationPro);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_locationCity);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthlandPro);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthlandCity);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_signature);
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_realName);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_incomeLevel);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_frequentPlaces);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_consumeHabits);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_email);
_PROPERTY_NONATOMIC_RETAIN(NSString, qb_homeRegisterTime);

@end
