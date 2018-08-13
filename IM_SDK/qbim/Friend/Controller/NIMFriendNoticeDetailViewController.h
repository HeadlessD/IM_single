//
//  NIMFriendNoticeDetailViewController.h
//  QianbaoIM
//
//  Created by xuguochen on 15/12/21.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMViewController.h"
#import "VcardEntity+CoreDataClass.h"
@class NewFriendEntity;

@interface NIMFriendNoticeDetailViewController : NIMViewController

@property (nonatomic, strong) VcardEntity *vcardEntity;

@end
