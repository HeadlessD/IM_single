//
//  NIMDefaultTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMGroupUserIcon.h"
//#import "PublicEntity.h"
#import "GroupList+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#define kDefaultReuseIdentifier @"kDefaultReuseIdentifier"

typedef NS_ENUM(NSInteger, FriendActionType) {
    FriendActionTypeTypeNone          = 0,
    FriendActionTypeTypeToAgree       = 1,
    FriendActionTypeTypeToAdd         = 2,
};

@protocol VcardTableViewCellDelegate;
@interface NIMDefaultTableViewCell : UITableViewCell<NIMGroupUserIconDelegate>{
    __unsafe_unretained id<VcardTableViewCellDelegate>_delegate;
    BOOL    _hasLineLeadingLeft;
}
@property (nonatomic, assign) id<VcardTableViewCellDelegate>delegate;
@property (nonatomic, strong) NIMGroupUserIcon *iconView;
@property (nonatomic, strong) UILabel   *titleLable;
@property (nonatomic, strong) UIView    *bottomLineView;

//@property (nonatomic, strong, readonly) VcardEntity *vcardEntity;
@property (nonatomic, strong, readonly) GroupList *groupEntity;
//@property (nonatomic, strong, readonly) PublicEntity *publicEntity;
@property (nonatomic, assign) BOOL  hasLineLeadingLeft;
- (void)makeConstraints;
- (void)updateWithVcardEntity:(VcardEntity *)vcardEntity;
- (void)updateWithImage:(UIImage *)image name:(NSString *)name;
- (void)updateWithGroupEntity:(GroupList *)groupEntity;
//- (void)updateWithPublicEntity:(PublicEntity *)publicEntty;
- (void)updateWithMemberEntity:(GMember *)memberEntity;
@end

@protocol VcardTableViewCellDelegate <NSObject>

@required
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell;

@optional
- (void)tableViewCell:(NIMDefaultTableViewCell *)cell didSelectedWithType:(FriendActionType)type userid:(int64_t)userid;
@end
