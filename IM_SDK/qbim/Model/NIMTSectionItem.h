//
//  NIMTSectionItem.h
//  Zhyq
//
//  Created by zhangtie on 14-5-9.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMTSectionItem : NSObject
{
    NSInteger   _sectionIndex;     //item的section索引
    BOOL        _IsHidden;         //是否收缩
    BOOL        _IsSelectedAll;    //是否处于全选状态
}

@property(nonatomic)NSInteger   sectionIndex;
@property(nonatomic)BOOL        IsHidden;
@property(nonatomic)BOOL        IsSelectedAll;

@end
