//
//  NIMProgressImageView.h
//  QianbaoIM
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMProgressImageView : UIImageView
@property(nonatomic,retain) UIProgressView *progressView;
@property(nonatomic,retain) NSString *imageUrl;   //图片服务器地址

- (void)loadImage;
- (void)finishUpload;
@end
