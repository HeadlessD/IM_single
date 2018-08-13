//
//  NIMAuthorManager.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/9.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMAuthorManager : NSObject

@property(nonatomic,assign)BOOL isShow;

SingletonInterface(NIMAuthorManager);

- (void)getNetworkAuthorReturnResultWithBlock:(void(^)(NSString *resultStr))resultBlock;
@end
