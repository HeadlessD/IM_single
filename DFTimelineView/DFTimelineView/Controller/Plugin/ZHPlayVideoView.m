//
//  ZHPlayVideoView.m
//  ZHSmallVideoDemo
//
//  Created by Cloud on 2018/1/12.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import "ZHPlayVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "NIMInstallView.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "DFVideoDecoder.h"
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define ANIMATIONDURATION 0.3

@interface ZHPlayVideoView ()<VLCMediaPlayerDelegate>
@property(nonatomic, strong)AVPlayer *player;
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, strong)AVPlayerLayer *playerLayer;
@property(nonatomic, copy)ZHActionButtonBlock block;
@property(nonatomic, assign)BOOL isShow;
@property (nonatomic, strong) NIMInstallView *bgView;
@property (nonatomic, strong) DFVideoDecoder *decoder;
@property (nonatomic, strong) VLCMediaPlayer *vplayer;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end

@implementation ZHPlayVideoView

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url isShow:(BOOL)isShow {
    self = [super initWithFrame:frame];
    if (self) {
        _isShow = isShow;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zh_buttonClick:)];
        [self.videoView addGestureRecognizer:_tap];
        // 监听播放完成通知，用来重复播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zh_playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        if ([url.absoluteString rangeOfString:@"http"].location != NSNotFound ||
            [url.absoluteString rangeOfString:@"https"].location != NSNotFound) {
            NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:url.absoluteString]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [self createUI:[NSURL fileURLWithPath:filePath]];
            } else {
//                [self createUI:url];
                __weak typeof(self) weakSelf = self;
                [[DFFileManager sharedInstance] downloadVideoUrl:url.absoluteString success:^(BOOL success) {
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    if (success) {
                        [weakSelf createUI:[NSURL fileURLWithPath:filePath]];
                    } else {
                        [MBTip showTipsView:@"视频加载失败"];
                    }

                }];

                [DFFileManager sharedInstance].progessBlock = ^(NSProgress *downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.bgView.progress = downloadProgress.fractionCompleted;
                    });
                };
            }
            
            
        } else {
            NSFileManager *manager = [NSFileManager defaultManager];
            BOOL isDir = YES;
            if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
                [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if ([manager fileExistsAtPath:url.path]) {
                [self createUI:url];
            } else {
                [MBTip showTipsView:@"视频加载失败"];
            }
        }
        
    }
    return self;
}

- (void)createUI:(NSURL *)url {
    
//    DFVideoDecoder *decoder = [[DFVideoDecoder alloc] initWithFile:url.path];
//    decoder.delegate = self;
//    [decoder decode];
//    _decoder = decoder;
    // 创建播放器
//    _playerItem = [AVPlayerItem playerItemWithURL:url];
//    _player = [AVPlayer playerWithPlayerItem:_playerItem];
//    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//    _playerLayer.frame = self.layer.bounds;
//    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.layer addSublayer:_playerLayer];
//    [_player play];
    NSMutableDictionary *mediaDictonary = [NSMutableDictionary new];
    //设置缓存多少毫秒
    [mediaDictonary setObject:@"300" forKey:@"network-caching"];
    self.vplayer = [[VLCMediaPlayer alloc] init];
    self.vplayer.drawable = self.videoView;
    self.vplayer.delegate = self;
    self.vplayer.media = [VLCMedia mediaWithURL:url];
    [self.vplayer.media addOptions:mediaDictonary];
    [self.vplayer play];
    
    // 创建返回按钮
    if (!_isShow) {
        return;
    }
    [self.videoView removeGestureRecognizer:_tap];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 1000;
    [cancelBtn setImage:[UIImage imageNamed:@"video_return_0104"] forState:UIControlStateNormal];
    CGFloat cancelBtnW = 60.f;
    cancelBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    cancelBtn.frame = CGRectMake(cancelBtn.frame.origin.x, self.frame.size.height - cancelBtnW * 2, cancelBtnW, cancelBtnW);
    [cancelBtn addTarget:self action:@selector(zh_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    // 创建使用按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.tag = 1001;
    [confirmBtn setImage:[UIImage imageNamed:@"video_success_0104"] forState:UIControlStateNormal];
    [confirmBtn sizeToFit];
    confirmBtn.frame = cancelBtn.frame;
    [confirmBtn addTarget:self action:@selector(zh_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    // 移动
    [self zh_moveButton:cancelBtn value:(-50 * zScaleWidth - cancelBtn.frame.size.width)]; // 左移需要多加一个按钮的距离
    [self zh_moveButton:confirmBtn value:50 * zScaleWidth];
}


- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    if ([aNotification.object isKindOfClass:[VLCMediaPlayer class]]) {
        VLCMediaPlayerState state = self.vplayer.state;
        if (state == VLCMediaPlayerStateStopped) {
            [self.vplayer rewind];
        }
    }
}

- (void)zh_moveButton:(UIButton *)button value:(CGFloat)value {
    [UIView animateWithDuration:.3 animations:^{
        button.frame = CGRectMake(button.frame.origin.x + value, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
    }];
}

- (void)zh_playFinish {
    for (NSURLSessionTask *task in [DFFileManager sharedInstance].tasks) {
        [task cancel];
    }
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

+ (void)zh_playVideoWithUrl:(NSURL *)url isShow:(BOOL)isShow completion:(ZHActionButtonBlock)completion {
    [self zh_endPlay];
    ZHPlayVideoView *playView = [[ZHPlayVideoView alloc] initWithFrame:KEYWINDOW.bounds url:url isShow:isShow];
    playView.block = completion;
    [KEYWINDOW addSubview:playView];
}

+ (void)zh_endPlay {
    for (NSURLSessionTask *task in [DFFileManager sharedInstance].tasks) {
        [task cancel];
    }
    for (UIView *view in KEYWINDOW.subviews) {
        if ([view class] == [ZHPlayVideoView class]) {
            ZHPlayVideoView *playView = (ZHPlayVideoView *)view;
            [playView.player pause];
            [view removeFromSuperview];
        }
    }
}

- (void)zh_buttonClick:(UIButton *)button {
    [ZHPlayVideoView zh_endPlay];
    if (self.vplayer) {
        [self.vplayer stop];
    }
    if ([button isKindOfClass:[UIButton class]]) {
        self.block(button.tag - 1000 == 0 ? ZHActionButtonCancel : ZHActionButtonConfirm);
    } else {
        self.block(ZHActionButtonCancel);
    }
}

- (void)dealloc {
    _bgView = nil;
    _videoView = nil;
    self.vplayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(NIMInstallView *)bgView
{
    if (!_bgView) {
        _bgView = [[NIMInstallView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _bgView.userInteractionEnabled = YES;
        _bgView.trackTintColor = [UIColor clearColor];
        _bgView.progressTintColor = [UIColor darkGrayColor];
        _bgView.thicknessRatio = 1.0f;
        _bgView.center = self.center;
        [self.videoView addSubview:_bgView];
    }
    return _bgView;
}

-(UIView *)videoView
{
    if (!_videoView) {
        _videoView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_videoView];
    }
    return _videoView;
}

@end
