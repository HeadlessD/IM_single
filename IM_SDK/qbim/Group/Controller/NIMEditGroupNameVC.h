//
//  NIMEditGroupNameVC.h
//  QianbaoIM
//
//  Created by Yun on 14/9/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"
#import "GroupList+CoreDataClass.h"
typedef NS_ENUM(NSInteger, EditType) {
    groupEditType = 0,
    groupCardEditType  = 1,
};

@protocol NIMEditGroupNameVCDelegate <NSObject>

@optional
- (void)setingFinish:(GroupList*)groupEntity;

@end
@interface NIMEditGroupNameVC : NIMViewController
@property (nonatomic, strong) GroupList *groupEntity;
@property(nonatomic,assign)EditType  type;
@property (nonatomic, assign) id<NIMEditGroupNameVCDelegate>delegate;
@end
