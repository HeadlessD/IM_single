//
//  NIMRRightTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"

@interface NIMRRightTextCell : NIMRRightTableViewCell<MLEmojiLabelDelegate>
@property (nonatomic, strong) MLEmojiLabel *plaintextLabel;
@end
