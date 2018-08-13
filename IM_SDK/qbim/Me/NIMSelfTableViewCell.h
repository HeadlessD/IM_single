//
//  NIMSelfTableViewCell.h
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMSelfTableViewCell : UITableViewCell


@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;

@property(nonatomic,strong) UIImageView *picView1;
@property(nonatomic,strong) UIImageView *picView2;
@property(nonatomic,strong) UIImageView *picView3;
@property(nonatomic,strong) NSArray *pics;

-(void)getViewModelWithIndex:(NSIndexPath *)indexPath withVcard:(VcardEntity *)vcard;

@end
