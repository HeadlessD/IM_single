//
//  NIMModifyUserInfoParm.m
//  QianbaoIM
//
//  Created by liyan on 10/8/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMModifyUserInfoParm.h"

@implementation NIMModifyUserInfoParm

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_nickName);
- (void)setQb_nickName:(NSString *)qb_nickName
{
   __QWT_SET_RETAINPARM__(qb_nickName, @"nickName");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_sex);
- (void)setQb_sex:(NSString *)qb_sex
{
    __QWT_SET_RETAINPARM__(qb_sex, @"sex");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthday);
- (void)setQb_birthday:(NSString *)qb_birthday
{
    __QWT_SET_RETAINPARM__(qb_birthday, @"birthday");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_locationPro);
- (void)setQb_locationPro:(NSString *)qb_locationPro
{
    __QWT_SET_RETAINPARM__(qb_locationPro, @"locationPro");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_locationCity);
- (void)setQb_locationCity:(NSString *)qb_locationCity
{
    __QWT_SET_RETAINPARM__(qb_locationCity, @"locationCity");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthlandPro);
- (void)setQb_birthlandPro:(NSString *)qb_birthlandPro
{
    __QWT_SET_RETAINPARM__(qb_birthlandPro, @"birthlandPro");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_birthlandCity);
- (void)setQb_birthlandCity:(NSString *)qb_birthlandCity
{
    __QWT_SET_RETAINPARM__(qb_birthlandCity, @"birthlandCity");
}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_homeRegisterTime);
- (void)setQb_homeRegisterTime:(NSString *)qb_homeRegisterTime
{
    __QWT_SET_RETAINPARM__(qb_homeRegisterTime, @"homeRegisterTime");
}

//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_signature);
- (void)setQb_signature:(NSString *)qb_signature
{
    __QWT_SET_RETAINPARM__(qb_signature, @"signature");
}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_realName);
//- (void)setQb_realName:(NSString *)qb_realName
//{
//    __QWT_SET_RETAINPARM__(qb_realName, @"sex");
//}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_incomeLevel);
- (void)setQb_incomeLevel:(NSString *)qb_incomeLevel
{
    __QWT_SET_RETAINPARM__(qb_incomeLevel, @"incomeLevel");
}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_frequentPlaces);
- (void)setQb_frequentPlaces:(NSString *)qb_frequentPlaces
{
    __QWT_SET_RETAINPARM__(qb_frequentPlaces, @"frequentPlaces");
}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_consumeHabits);
- (void)setQb_consumeHabits:(NSString *)qb_consumeHabits
{
    __QWT_SET_RETAINPARM__(qb_consumeHabits, @"consumeHabits");
}
//_PROPERTY_NONATOMIC_RETAIN(NSString, qb_email);
- (void)setQb_email:(NSString *)qb_email
{
    __QWT_SET_RETAINPARM__(qb_email, @"email");
}

@end
