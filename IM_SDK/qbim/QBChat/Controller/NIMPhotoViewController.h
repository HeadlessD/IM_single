//
//  CCPhotoViewController.h
//  CustomCamera
//
//  Created by zhouke on 16/9/1.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMPhotoViewController;

@protocol NIMPhotoViewControllerDelegate <NSObject>

- (void)photoViewController:(NIMPhotoViewController *)picker didSendImage:(NSDictionary *)imageDict;

@end

@interface NIMPhotoViewController : UIViewController

@property (nonatomic, strong) NSDictionary *imageDict;
@property (nonatomic, weak) id<NIMPhotoViewControllerDelegate>delegate;

@end
