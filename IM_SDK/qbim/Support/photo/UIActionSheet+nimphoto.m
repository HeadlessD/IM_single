//
//  UIActionSheet+nimphoto.m
//  Qianbao
//
//  Created by liyan1 on 13-4-19.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import "UIActionSheet+nimphoto.h"
#import <AVFoundation/AVFoundation.h>
//#import "NIMQBChooseImageViewController.h"
#import "UIViewController+NIMQBaoUI.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@implementation UIActionSheet (nimphoto)

+ (id)nim_actionSheetWithDelegate:(id<UIActionSheetDelegate>)delegate
{
    UIActionSheet *_actionSheet = nil;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"拍照上传", @""), NSLocalizedString(@"从相册上传", @""), nil];
        
    } else {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"从相册上传", @""), nil];
    }
    [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    return _actionSheet;
}

+ (BOOL)nim_checkCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"对不起,你的设备不能拍照!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

+ (BOOL)nim_checkPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"对不起,你的设备没有图片库!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

+ (void)nim_canPhotoLibraryWithYES:(void(^)(void))yesAction withNO:(void(^)(void))noAction
{
    if (@available(iOS 11.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-照片\"中允许访问照片。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            noAction();
        }else{
            yesAction();
        }
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        //    ALAuthorizationStatusNotDetermined = 0, 用户尚未做出了选择这个应用程序的问候
        //
        //    ALAuthorizationStatusRestricted,        此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        //    ALAuthorizationStatusDenied,            用户已经明确否认了这一照片数据的应用程序访问.
        //    ALAuthorizationStatusAuthorized         用户已授权应用访问照片数据.
        if(author ==ALAuthorizationStatusAuthorized || author == ALAuthorizationStatusNotDetermined)
        {
            yesAction();
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-隐私-照片\"中允许访问照片。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            noAction();
        }

    }
    
    

}


+ (void)nim_canCameraWithYES:(void(^)(void))yesAction withNO:(void(^)(void))noAction
{
//    NSString* first = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunch"];
//    if(!first){
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLaunch"];
//        yesAction();
//        return;
//    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //表示没有开启摄像头权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-通用-访问限制-相机\"中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        noAction();
        return;
    }
    else
    {
        yesAction();
    }
#else
    float systemName = [[[UIDevice currentDevice]systemVersion]floatValue];
    if(systemName >= 7.0)
    {
        //
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //表示没有开启摄像头权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-通用-访问限制-相机\"中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            noAction();
            return;
        }
        
        NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        DBLog(@"---cui--authStatus--------%ld",(long)authStatus);
        // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
        if(authStatus ==AVAuthorizationStatusRestricted)
        {
            DBLog(@"Restricted");
            yesAction();
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // The user has explicitly denied permission for media capture.
            DBLog(@"Denied");     //应该是这个，如果不允许的话
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            noAction();
            return;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized)
        {//允许访问
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            DBLog(@"Authorized");
            yesAction();
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){//点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    DBLog(@"Granted access to %@", mediaType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        yesAction();
                    });
                    
                }
                else {
                    DBLog(@"Not granted access to %@", mediaType);
                    noAction();
                }
                
            }];
        }
        else
        {
            noAction();
            DBLog(@"Unknown authorization status");
        }
    }
    else
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //表示没有开启摄像头权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-通用-访问限制-相机\"中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            noAction();
            return;
        }
        else
        {
            yesAction();
        }
    }
#endif
}



- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                                        animated:(BOOL)animated
{
    [self nim_presentUIImagePickerControllerWithTarget:target clickedButtonAtIndex:buttonIndex allowsMultipleSelection:NO animated:animated];
}

- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                         allowsMultipleSelection:(BOOL)allowsMultipleSelection
                                        animated:(BOOL)animated
{
    
    [self nim_presentUIImagePickerControllerWithTarget:target clickedButtonAtIndex:buttonIndex allowsMultipleSelection:allowsMultipleSelection animated:animated edit:NO];
}

- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                         allowsMultipleSelection:(BOOL)allowsMultipleSelection
                                        animated:(BOOL)animated
                                            edit:(BOOL)edit
{
    
    int photoNeeded = 0;
    int imageSelectNeeded = 1;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        photoNeeded = -999;
        imageSelectNeeded = 0;
    }
    if(buttonIndex == photoNeeded)
    {
        [UIActionSheet nim_canCameraWithYES:^{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = target;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if(edit)
            {
                imagePicker.allowsEditing = YES;
            }
            [target presentModalViewController:imagePicker animated:YES];
        } withNO:^{
            
        }];
    }
    if(buttonIndex == imageSelectNeeded)
    {
        if([UIActionSheet nim_checkPhotoLibrary])
        {
            if(edit)
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = target;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                [target presentViewController:imagePicker animated:YES completion:^{
//                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                }];
                
            }
            else
            {
//                NIMQBChooseImageViewController *imagePickerController = [[NIMQBChooseImageViewController alloc]init];
//                imagePickerController.delegate = target;
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//                [(UIViewController *)target presentViewController:navigationController animated:YES completion:^{
//                    
//                }];
            }
        }
        
    }
}

-(void)nim_newCheckPhoto
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        // 无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许该应用访问您的相机\n设置>隐私>相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
}
@end
