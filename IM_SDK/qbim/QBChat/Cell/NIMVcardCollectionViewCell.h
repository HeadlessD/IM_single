//
//  NIMVcardCollectionViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kvcardIdentifier    @"vcardCollectionViewCell"

@protocol VcardCollectionViewCellDelegate;
@interface NIMVcardCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, assign) id<VcardCollectionViewCellDelegate>vcardDelegate;
@property (nonatomic, assign) double uid;
@property (nonatomic, strong) UILabel *lbIsGroupMaster;
@property (nonatomic, strong) UIImageView *delImgView;
@end

@protocol VcardCollectionViewCellDelegate <NSObject>

@required
- (void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIButton *)avatar;

@end
