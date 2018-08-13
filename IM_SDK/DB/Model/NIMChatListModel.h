//
//  NIMChatListModel.h
//  qbnimclient
//
//  Created by 秦雨 on 17/12/13.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMChatListModel : NSObject

@property (nonatomic, strong) NSString *mbd;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isRead;

@end
