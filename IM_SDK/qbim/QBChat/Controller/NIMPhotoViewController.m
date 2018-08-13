//
//  CCPhotoViewController.m
//  CustomCamera
//
//  Created by zhouke on 16/9/1.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import "NIMPhotoViewController.h"

@interface NIMPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NIMPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (_imageDict.count>0) {
        UIImage *image = [_imageDict objectForKey:@"original"];
        self.imageView.image = image;
    }
    
    self.imageView.userInteractionEnabled = YES;
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2-25), SCREEN_HEIGHT-100, 50, 50)];
    
    sendBtn.layer.cornerRadius = 25;
    [sendBtn setBackgroundImage:IMGGET(@"bank_auth_success") forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(didSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imageView addSubview:sendBtn];
    
    
}
- (IBAction)closeClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)didSend:(UIImage *)image
{
    if ([_delegate respondsToSelector:@selector(photoViewController:didSendImage:)]) {
        if (_imageDict.count>0) {
            [_delegate photoViewController:self didSendImage:_imageDict];
            UIImage *image = [_imageDict objectForKey:@"original"];
            [SSIMSpUtil saveImageToAlbum:image withAlert:NO];
        }
        
    }
}

@end
