//
//  NIMProgressImageView.m
//  QianbaoIM
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMProgressImageView.h"
//#import "NIMManager+MainThread.h"
//#import "UIProgressView+AFNetworking.h"
@implementation NIMProgressImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, self.frame.size.height- 10, self.frame.size.width-20, 7)];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
                self.progressView.transform = transform;
        self.progressView.hidden = NO;
        self.progressView.trackTintColor = COLOR_RGBA(220, 202, 190, 1);
        self.progressView.progressTintColor = COLOR_RGBA(220, 23, 19, 1);
        [self addSubview:self.progressView];

    }
    return self;
}

//- (void)uploadImage:(UIImage *)image ApiUrl:(NSString *)apiUrl {
//    UIImage * avataFile = IMGGET(@"1.png"];
//    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:4];
//    SET_PARAM(avataFile, @"avataFile", parms);
//    
//    AFHTTPRequestOperation *operation = [[NIMManager sharedImManager] getAFHTTPRequestOperationWithUrl:SERVERURL_upLoadUserAvatar param:parms successBlock:^(id object, NIMResultMeta *result) {
//        //
//        
//    } failedBlock:^(id object, NIMResultMeta *result) {
//        //
//    }];
//    [self.progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
//}

- (void)finishUpload{
    [self.progressView setProgress:1 animated:YES];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.2];
}
- (void)dismiss{
    self.progressView.hidden = YES;
}

- (void)loadImage{
    self.progressView.hidden = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@"@"/200",self.imageUrl];
    NSURL *imageUrl = [NSURL URLWithString:urlStr];
    UIImage *defaultImage = IMGGET(@"bg_dialog_pictures");
    if (!self.image) {
        self.image = defaultImage;
    }
    [self sd_setImageWithPreviousCachedImageWithURL:imageUrl placeholderImage:self.image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
