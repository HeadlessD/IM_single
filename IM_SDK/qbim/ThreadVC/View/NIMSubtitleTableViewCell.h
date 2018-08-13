//
//  NIMSubtitleTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"
#import "MLEmojiLabel.h"

#define kSubtitleReuseIdentifier @"kSubtitleReuseIdentifier"
@interface NIMSubtitleTableViewCell : NIMDefaultTableViewCell
@property (nonatomic, strong) MLEmojiLabel   *introLablel;
@property (nonatomic, strong) UIImageView   *infoImg;
- (void)updateWithName:(NSString *)name icon:(NSString *)icon intro:(NSString *)intro;
@end
