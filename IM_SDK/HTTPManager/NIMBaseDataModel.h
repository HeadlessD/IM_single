//
//  NIMBaseDataModel.h
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_MODEL_DATACOUNT       @"totalCount"
#define KEY_MODEL_DATALIST        @"dataList"

@interface NIMBaseDataModel : NSObject<NSCoding>

+ (id)baseDataWithDecode:(NSString *)userID;

- (id)initWithDict:(NSDictionary *)dict;

- (void)saveToLocal;

- (void)clearLocal;

- (NSString *)savaName;

@end
