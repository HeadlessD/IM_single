//
//  NIMLLCameraViewController.m
//
//
//  Created by on 16/8/23.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "NIMLLCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const kPublicImageMediaType = @"public.image";

@interface NIMLLCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) CameraBlock cameraBlock;

@end

@implementation NIMLLCameraViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ((authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) && IOS_VERSION >= 8.0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alertView show];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.delegate = self;
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (IOS_VERSION >= 8.0) {
                self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
        } else {
            NSLog(@"设备不支持照相功能");
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@", self);
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:kPublicImageMediaType]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([_lldelegate respondsToSelector:@selector(cameraViewController:didFinishPickingImage:)]) {
            [_lldelegate cameraViewController:self didFinishPickingImage:@{@"original":image}];
        }
//        if (self.cameraBlock) {
//            self.cameraBlock(image,info);
//        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) { } else {
        NSLog(@"设置");
        if (IOS_VERSION >= 8.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (void)getResultFromCameraWithBlock:(CameraBlock)block {
    self.cameraBlock = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
