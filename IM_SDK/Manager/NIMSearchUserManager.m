//
//  NIMSearchUserManager.m
//  QBNIMClient
//
//  Created by 豆凯强 on 17/5/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMSearchUserManager.h"
#import "NIMManager.h"


@implementation NIMSearchUserManager
SingletonImplementation(NIMSearchUserManager)

-(void)getSelfInfoSuccessPacket:(int64)userId{
    //暂时不用
    //    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@(userId) forKey:@"userId"];
    //    [dict setValue:@1 forKey:@"success"];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NC_ME_INFO_RQ object:nil userInfo:dict];
}

-(void)getSelfInfoFailureSearchCon:(NSString *)searchCon errorStr:(NSString *)errorStr
{
    NSMutableArray * userArr = [NSMutableArray array];
    
    [userArr addObject:@{@(key_user_name):[NSString stringWithFormat:@"FC_%lld",OWNERID]}];
    [userArr addObject:@{@(key_birthday):@"0"}];
    [userArr addObject:@{@(key_mobile):[[NSUserDefaults standardUserDefaults]objectForKey:@"userMobile"]}];
    [userArr addObject:@{@(key_mail):[NSString stringWithFormat:@"%d@qq.com",arc4random()%10000]}];
    [userArr addObject:@{@(key_city):@"北京"}];
    [userArr addObject:@{@(key_nick_name):[NSString stringWithFormat:@"FC_%lld",OWNERID]}];
    [userArr addObject:@{@(key_sex):[NSString stringWithFormat:@"%d",arc4random()%2]}];
    [userArr addObject:@{@(key_province):@"东城区"}];
    [userArr addObject:@{@(key_signature):@"暂未填写个人签名"}];
    [[NIMUserOperationBox sharedInstance]sendUpdateUserInfoRQ:userArr sessionID:nil];
    
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setValue:@0 forKey:@"success"];
//    [dict setValue:searchCon forKey:@"searchCon"];
//    [dict setValue:errorStr forKey:@"error"];
    
//    [[NIMManager sharedImManager]fetchSelfUsesrInfoCompleteBlock:^(id object, id responseObject) {
//        NSDictionary * dic_respon = responseObject;
//        NSDictionary * dic_object = dic_respon[@"data"];
//
//        if ((dic_object == [NSNull null]) ||
//            [responseObject isKindOfClass:[NIMResultMeta class]] ||
//            ([[responseObject objectForKey:@"errorCode"] intValue] != 0) ||
//            (!IsStrEmpty([responseObject objectForKey:@"errorMsg"]))) {
//
//            NSLog(@"result_message:%@",responseObject);
//        }else{
//            NSMutableArray * userArr = [NSMutableArray array];
//
//            if (!IsStrEmpty([dic_object objectForKey:@"userName"])) {
//                [userArr addObject:@{@(key_user_name):[dic_object objectForKey:@"userName"]}];
//            }
//
//            NSString * birthdayForDic = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"birthday"]];
//            if (!IsStrEmpty(birthdayForDic)) {
//
////                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////                //指定时间显示样式: HH表示24小时制 hh表示12小时制
////                [formatter setDateFormat:@"yyyy-MM-dd"];
////                NSString * dateStr = birthdayForDic;
////                NSDate *lastDate = [formatter dateFromString:dateStr];
////                //以 1970/01/01 GMT为基准，得到lastDate的时间戳
////                long firstStamp = [lastDate timeIntervalSince1970];
////                NSString * dateBir = [NSString stringWithFormat:@"%ld000",firstStamp];
//                NSString * dateBir = [SSIMSpUtil creatTimeWithBirthday:birthdayForDic];
//                [userArr addObject:@{@(key_birthday):dateBir}];
//             }
//
//            if (!IsStrEmpty([dic_object objectForKey:@"mobile"])) {
//                [userArr addObject:@{@(key_mobile):[dic_object objectForKey:@"mobile"]}];
//            }
//            NSString * email = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"userRouteEmail"]];
//            if (!IsStrEmpty(email)) {
//                [userArr addObject:@{@(key_mail):email}];
//            }
//
//            NSString * homePlaceCity = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"locationPlaceCity"]];
//            if (!IsStrEmpty(homePlaceCity)) {
//                [userArr addObject:@{@(key_city):homePlaceCity}];
//            }
//            NSString * nickName = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"nickName"]];
//            if (!IsStrEmpty(nickName)) {
//                [userArr addObject:@{@(key_nick_name):nickName}];
//            }
//            NSString * sex = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"sex"]];
//            if (!IsStrEmpty(sex)) {
//                if ([sex isEqualToString:@"M"]) {
//                    sex = @"1";
//                }else if ([sex isEqualToString:@"F"]){
//                    sex = @"0";
//                }
//                [userArr addObject:@{@(key_sex):sex}];
//            }
//            NSString * locationPlaceProvince = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"locationPlaceProvince"]];
//            if (!IsStrEmpty(locationPlaceProvince)) {
//                [userArr addObject:@{@(key_province):locationPlaceProvince}];
//            }
//            NSString * signature = [NSString stringWithFormat:@"%@",[dic_object objectForKey:@"selfIntroduction"]];
//            if (!IsStrEmpty(signature)) {
//                [userArr addObject:@{@(key_signature):signature}];
//            }
//            if (userArr.count>0){
//                [[NIMUserOperationBox sharedInstance]sendUpdateUserInfoRQ:userArr sessionID:nil];
//            }
//        }
//    }];
}


-(void)getUserInfoSuccessPacket:(int64)userId type:(int32)type{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(userId) forKey:@"userId"];
    [dict setValue:@1 forKey:@"success"];
    
    switch (type) {
            
        case Search_AddView:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERINFO_RQ_ForAddView object:nil userInfo:dict];
        }break;
        case Search_PeedView:{
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERINFO_RQ_ForPeedView object:nil userInfo:dict];
        }break;
        default:
            break;
    }
}

-(void)getUserInfoFailureSearchCon:(NSString *)searchCon errorStr:(NSString *)errorStr type:(int32)type{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@0 forKey:@"success"];
    [dict setValue:searchCon forKey:@"searchCon"];
    [dict setValue:errorStr forKey:@"error"];
    
    if (type == Search_AddView){
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERINFO_RQ_ForAddView object:nil userInfo:dict];
    }else if (type == Search_PeedView){
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERINFO_RQ_ForPeedView object:nil userInfo:dict];
    }
}

@end
