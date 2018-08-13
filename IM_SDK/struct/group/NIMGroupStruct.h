//
//  GroupStruct.h
//  qbim
//
//  Created by 秦雨 on 17/2/13.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMHeader.h"
@interface QBCreateGroup : NIMHeader

@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *group_img_url;
@property (nonatomic,strong) NSString *group_remark;
@property (nonatomic,assign) int64_t group_ct;
@property (nonatomic,strong) NSArray *user_info_list;

@end

@interface QBUserBaseInfo : NSObject
@property (nonatomic,strong) NSString *user_nick_name;
@property (nonatomic,assign) uint64_t user_id;
@property (nonatomic,assign) int16_t user_group_index;
@end
@interface NIMGroupTypeInfo : NSObject
@property (nonatomic,assign) int group_max_count;
@property (nonatomic,assign) int group_is_show;
@property (nonatomic,assign) int group_type;
@property (nonatomic,assign) int group_add_max_count;

@end
