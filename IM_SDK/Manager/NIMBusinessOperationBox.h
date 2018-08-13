//
//  NIMBusinessOperationBox.h
//  qbnimclient
//
//  Created by 秦雨 on 17/11/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMBusinessOperationBox : NSObject
SingletonInterface(NIMBusinessOperationBox)

//获取在线小二
-(void)getFreeWaiter:(int64_t)bid wid_list:(NSArray *)wid_list;

//上传商家信息
-(void)setBusinessInfo:(SSIMBusinessModel *)info;

//获取商家信息
-(void)getBusinessInfo:(int64_t)sellerid;

-(NSDictionary *)getJsonInfoByBusinessModel:(id)model;
@end
