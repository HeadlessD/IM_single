//
//  QBHeader.h
//  qbim
//
//  Created by 秦雨 on 17/2/13.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMHeader : NSObject
@property (nonatomic,assign) int64_t user_id;
@property (nonatomic,assign) int session_id;
@property (nonatomic,assign) BYTE platform;
@end
