//
//  CCCameraViewController.m
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import "NIMCameraViewController.h"
#import "NIMCameraManger.h"
#import "NIMPhotoViewController.h"
#import "UIImage+NIMEllipse.h"
@interface NIMCameraViewController ()<NIMPhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIButton *transformBtn;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightSwitchBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) NIMCameraManger *manger;

@end

@implementation NIMCameraViewController

-(void)dealloc
{
    [self.manger.cmmotionManager stopAccelerometerUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.manger startUp];
}

- (IBAction)closeClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)transformAction:(UIButton *)sender
{
    self.transformBtn.selected = !self.transformBtn.selected;
    [self.manger changeCameraInputDeviceisFront:sender.selected];
    if (self.transformBtn.selected == YES) { // 切换为前置镜头关闭闪光灯
        self.lightSwitchBtn.selected = NO;
        [self.manger closeFlashLight];
    }
}

- (IBAction)lightSwitchAcrion:(UIButton *)sender
{
    if (self.transformBtn.selected) { // 当前为前置镜头的时候不能打开闪光灯
        return;
    }
    self.lightSwitchBtn.selected = !self.lightSwitchBtn.selected;
    if (self.lightSwitchBtn.selected) {
        [self.manger openFlashLight];
    } else {
        [self.manger closeFlashLight];
    }
}

- (IBAction)takePhotoAction:(id)sender
{
    [self.manger takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
        self.lightSwitchBtn.selected = NO; // 拍照完成后会自动关闭闪光灯
        
        NIMPhotoViewController *photo = [[NIMPhotoViewController alloc] initWithNibName:@"NIMPhotoViewController" bundle:[NSBundle mainBundle]];
        
//        UIImage *chatImg = nil;
//        
//        if (originImage) {
//            CGSize cs = [SSIMSpUtil getChatImageSize:originImage];
//            chatImg = [SSIMSpUtil imageCompressForSize:originImage targetSize:cs];
//        }
        CGFloat W = originImage.size.width;
        CGFloat H = originImage.size.height;

        if (W>H) {
            CGSize tagetSize = CGSizeMake(SCREEN_WIDTH*H/W, SCREEN_WIDTH);
            originImage = [SSIMSpUtil scaleFromImage:originImage toSize:tagetSize];

        }
        
        originImage = [UIImage nim_transferImage:originImage orientation:UIImageOrientationRight];
        if (originImage.size.width>originImage.size.height &&
            W<H) {
            CGSize tagetSize = CGSizeMake(originImage.size.height, originImage.size.width);
            originImage = [SSIMSpUtil scaleFromImage:originImage toSize:tagetSize];
            
        }
        
        NSDictionary *dict = @{@"original":originImage};
        photo.delegate = self;
        photo.imageDict = dict;
        [self presentViewController:photo animated:YES completion:^{
        }];
    }];
}


-(void)photoViewController:(NIMPhotoViewController *)picker didSendImage:(NSDictionary *)imageDict
{
    if ([_delegate respondsToSelector:@selector(cameraViewController:didFinishPickingImage:)]) {
        [_delegate cameraViewController:self didFinishPickingImage:imageDict];
    }
}

- (NIMCameraManger *)manger
{
    if (!_manger) {
        _manger = [[NIMCameraManger alloc] initWithParentView:self.preview];
        _manger.faceRecognition = YES;
    }
    return _manger;
}

@end
