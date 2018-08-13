//
//  CCCameraViewController.h
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMCameraViewController;

@protocol NIMCameraViewControllerDelegate <NSObject>

- (void)cameraViewController:(NIMCameraViewController *)picker didFinishPickingImage:(NSDictionary *)imageDict;

@end

@interface NIMCameraViewController : UIViewController

@property (nonatomic, weak) id<NIMCameraViewControllerDelegate>delegate;

@end
