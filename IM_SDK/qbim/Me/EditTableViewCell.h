//
//  EditTableViewCell.h
//  qbnimclient
//
//  Created by shiyunjie on 2018/1/4.
//  Copyright © 2018年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIImageView *icon;

-(void)getViewModelWithIndex:(NSIndexPath *)indexPath withVcard:(VcardEntity *)vcard;

@end
