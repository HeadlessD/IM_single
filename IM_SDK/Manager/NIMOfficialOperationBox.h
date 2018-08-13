//
//  NIMOfficialOperationBox.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/5/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMOffcialInfo.h"
@interface NIMOfficialOperationBox : NSObject

SingletonInterface(NIMOfficialOperationBox);

-(void)addOffcialInfo:(NIMOffcialInfo *)info;

@end
