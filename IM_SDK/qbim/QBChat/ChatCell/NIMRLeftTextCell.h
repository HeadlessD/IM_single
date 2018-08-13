//
//  NIMRLeftTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTableViewCell.h"

@interface NIMRLeftTextCell : NIMRLeftTableViewCell<MLEmojiLabelDelegate>
@property (nonatomic, strong) MLEmojiLabel *plaintextLabel;
@end
