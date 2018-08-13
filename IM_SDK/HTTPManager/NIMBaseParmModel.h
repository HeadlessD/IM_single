//
//  BaseParmModel.h
//  IOS7Test
//
/********************************************使用示例*********************************************************/
//
//
//    @interface QWTLoginParm : QWTBaseParmModel
//
//    _PROPERTY_NONATOMIC_RETAIN(NSString, accountName);
//
//    _PROPERTY_NONATOMIC_RETAIN(NSString, accountPass);
//
//    @end
//
//  备注:由于参数是json格式所以必须重写Setter方法, setter方式如下
//
//    - (void)setAccountName:(NSString *)accountName
//    {
//        __QWT_SET_RETAINPARM__(accountName, @"cell");
//    }
//
//    - (void)setAccountPass:(NSString *)accountPass
//    {
//        __QWT_SET_RETAINPARM__(accountPass, @"pwd");
//    }
/********************************************使用示例*********************************************************/
//
//  Created by zhangtie on 13-11-6.
//  Copyright (c) 2013年 zhangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __QWT_SET_RETAINPARM__(__property__, __key__)\
{\
    __SETTER_RETAIN__(__property__)\
    [self setParm:__property__ forKey:__key__];\
}

#define __QWT_SET_RETAIN_INTPARM__(__property__, __key__)\
{\
    _##__property__ = __property__;\
    [self setParm:[NSString stringWithFormat:@"%d", __property__] forKey:__key__];\
}

#define __QWT_SET_RETAIN_ARRAYPARM__(__property__, __key__)\
{\
    __SETTER_RETAIN__(__property__)\
    [self setParm:[QWUtil jsonStringWithArray:__property__] forKey:__key__];\
}

@protocol NIMBaseParmModelProtocol <NSObject>

@optional
+ (id)parmObjNew;      //创建一个自动释放的实例

@end

@interface NIMBaseParmModel : NSObject<NIMBaseParmModelProtocol>

- (NSDictionary*)parm2jsonObj;  //请求传输时需转成字典给ztrequst

- (void)setParm:(id)parmVal forKey:(NSString*)parmName;

- (void)removeParmForKey:(NSString*)parmKey;

- (id)parmValForKey:(NSString*)key;

+ (NIMBaseParmModel*)parmFromDict:(NSDictionary*)dict;

@end
