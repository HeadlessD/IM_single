//
//  NIMLLCameraViewController.h
//
//
//  Created by  on 16/8/23.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Config.h"
@class NIMLLCameraViewController;

typedef void (^CameraBlock) (UIImage *image, NSDictionary *info);

@protocol NIMLLCameraViewControllerDelegate <NSObject>

- (void)cameraViewController:(NIMLLCameraViewController *)picker didFinishPickingImage:(NSDictionary *)imageDict;

@end

@interface NIMLLCameraViewController : UIImagePickerController

@property (nonatomic, weak) id<NIMLLCameraViewControllerDelegate>lldelegate;

/** 拍摄照片回调方法
 * @brief image: 拍摄获取的图片, info: 图片的相关信息
 */
- (void)getResultFromCameraWithBlock:(CameraBlock)block;

@end
