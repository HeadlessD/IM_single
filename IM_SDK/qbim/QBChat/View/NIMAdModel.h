//
//  NIMAdModel.h
//  QianbaoIM
//
//  Created by xuqing on 16/3/24.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMAdModel : NSObject
@property(nonatomic,strong)NSString *adtitle;
@property(nonatomic,strong)NSString *adUrl;
-(id)initWithDic:(NSDictionary*)dic;
@end
