//
//  NIMKvoStruct.h
//  qbim
//
//  Created by ssQINYU on 17/1/22.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSingelton.h"
@interface NIMKvoStruct : NSObject
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL isFetchFriendSuccess;
@property(nonatomic,assign)int userInfoType;
SingletonInterface(NIMKvoStruct)
@end
