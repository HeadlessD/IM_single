//
//  NIMErrorManager.h
//  qbim
//
//  Created by shiyunjie on 17/3/14.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMErrorManager : NSObject
{
@private
    NSMutableDictionary *err_msg_dic;
}

SingletonInterface(NIMErrorManager)
-(void) initErrorDetail;
-(NSString*) getErrorDetail:(uint64_t) error_code;
-(void) setErrorDetail:(unsigned int) error_code detail:(NSString *)detail;
@end
