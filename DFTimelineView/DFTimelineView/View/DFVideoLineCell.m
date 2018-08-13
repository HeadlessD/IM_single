//
//  DFVideoLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFVideoLineCell.h"
#import "MLLabel+Size.h"

#import "NSString+MLExpression.h"

#import "DFFaceManager.h"

#import "DFVideoLineItem.h"

#import "DFToolUtil.h"
#import "DFSandboxHelper.h"

#import "DFVideoPlayController.h"
#import "UIImage+NIMEffects.h"
#import "ZLDefine.h"
#import "ZHPlayVideoView.h"
#define TextFont [UIFont systemFontOfSize:14]

#define TextLineHeight 1.2f

#define TextVideoSpace 10

#define VideoWidth (BodyMaxWidth)*0.4
#define VideoHeight (VideoWidth)*16/9.0

#define VideoCell @"timeline_cell_video"

@interface DFVideoLineCell()<DFVideoDecoderDelegate>

@property (strong, nonatomic) MLLinkLabel *textContentLabel;

@property (strong, nonatomic) UIImageView *videoView;

@property (strong, nonatomic) UIButton *clickButton;

@property (strong, nonatomic) DFVideoLineItem *videoItem;

@property (assign, nonatomic) NSInteger currentRow;

@property (strong, nonatomic) UIImageView *playView;

@end

@implementation DFVideoLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCell];
    }
    return self;
}


-(void) initCell
{
    
    if (_textContentLabel == nil) {
        
        _textContentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.font = TextFont;
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.adjustsFontSizeToFitWidth = NO;
        _textContentLabel.textInsets = UIEdgeInsetsZero;
        
        _textContentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _textContentLabel.allowLineBreakInsideLinks = NO;
        _textContentLabel.linkTextAttributes = nil;
        _textContentLabel.activeLinkTextAttributes = nil;
        _textContentLabel.lineHeightMultiple = TextLineHeight;
        _textContentLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        
        [_textContentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
        }];
        
        
        [self.bodyView addSubview:_textContentLabel];
    }
    
    if (_videoView == nil) {
        
        CGFloat x, y , width, height;
        
        x = 0;
        y = 0;
        width = VideoWidth;
        height = VideoHeight;
        
        _videoView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.bodyView addSubview:_videoView];
        
        _playView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
        _playView.center = _videoView.center;
        _playView.userInteractionEnabled = YES;
        _playView.image = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"playVideo")];
        [_videoView addSubview:_playView];
        
        _clickButton = [[UIButton alloc] initWithFrame:_videoView.frame];
        [self.bodyView addSubview:_clickButton];
        [_clickButton addTarget:self action:@selector(onClickVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(void) onClickVideo:(id) sender
{
    NSURL *videoUrl;
    if (IsStrEmpty(_videoItem.localVideoPath)) {
        NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:_videoItem.videoUrl]];
        BOOL isDir = YES;
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
            [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([manager fileExistsAtPath:filePath]) {
            videoUrl = [NSURL fileURLWithPath:filePath];
        }else{
            videoUrl = [NSURL URLWithString:_videoItem.videoUrl];
        }
    } else {
        videoUrl = [NSURL fileURLWithPath:_videoItem.localVideoPath];
    }
    
    [ZHPlayVideoView zh_playVideoWithUrl:videoUrl isShow:NO completion:^(ZHActionButtonType btnType) {
        
    }];
}


-(void)updateWithItem:(DFVideoLineItem *)item forRow:(NSInteger)row
{
    [super updateWithItem:item forRow:row];
    _currentRow = row;
    _videoItem = item;
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    _textContentLabel.attributedText = item.attrText;
    [_textContentLabel sizeToFit];
    
    _textContentLabel.frame = CGRectMake(0, 0, BodyMaxWidth, textSize.height);
    
    
    CGFloat x, y, width, height;
    x = _videoView.frame.origin.x;
    y = CGRectGetMaxY(_textContentLabel.frame)+TextVideoSpace;
    width = _videoView.frame.size.width;
    height = _videoView.frame.size.height;
    _videoView.frame = CGRectMake(x, y, width, height);
    [self updateBodyView:(textSize.height+VideoHeight+TextVideoSpace)];
    [self setPreImage];
}


- (void)setPreImage {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = YES;

    if (_videoItem.thumbImage != nil) {
        _videoView.image = _videoItem.thumbImage;
    } else if (_videoItem.thumbUrl != nil) {
        if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
            [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:_videoItem.thumbUrl]];
        if ([manager fileExistsAtPath:filePath]) {
            _videoView.image = [UIImage imageWithContentsOfFile:filePath];
            _videoItem.thumbImage = [UIImage imageWithContentsOfFile:filePath];
        } else {
            [_videoView sd_setImageWithURL:[NSURL URLWithString:_videoItem.thumbUrl]];
            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:_videoItem.thumbUrl];
        }
    } else if (_videoItem.localVideoPath != nil && ![_videoItem.localVideoPath isEqualToString:@""]) {
        
        if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
            [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filePath = _videoItem.localVideoPath;
        
        if ([manager fileExistsAtPath:filePath]) {
            _videoItem.thumbImage = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:_videoItem.localVideoPath]];
            _videoView.image = _videoItem.thumbImage;
        }else{
            _videoView.image = IMGGET(@"bg_dialog_pictures");
//            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:_videoItem.videoUrl];
        }
    } else if (_videoItem.videoUrl != nil && ![_videoItem.videoUrl isEqualToString:@""]) {
        NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",DF_CACHEPATH, [DFToolUtil md5:_videoItem.videoUrl]];
        if (![manager fileExistsAtPath:DF_CACHEPATH isDirectory:&isDir]) {
            [manager createDirectoryAtPath:DF_CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([manager fileExistsAtPath:filePath]) {
            _videoView.image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:filePath]];
            _videoItem.thumbImage = _videoView.image;
        } else {
            _videoView.image = IMGGET(@"bg_dialog_pictures");
//            [[DFFileManager sharedInstance] saveFileToLocal:filePath url:_videoItem.videoUrl];
        }
    }
}


-(void) downloadFinish:(NSString *) filePath
{
    _videoItem.localVideoPath = filePath;
    [self setPreImage];
//    [self decodeVideo];
}

-(void) decodeVideo
{
    if (_videoItem.decorder == nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DFVideoDecoder *decoder = [[DFVideoDecoder alloc] initWithFile:_videoItem.localVideoPath];
            decoder.delegate = self;
            _videoItem.decorder = decoder;
            [decoder decode];
        });
    }else{
        [self onDecodeFinished];
    }
}

-(void)onDecodeFinished
{
    //解码完成 刷新界面
    NSLog(@"解码完成");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_videoItem.decorder.animation != nil) {
            [_videoView.layer removeAnimationForKey:@"contents"];
            [_videoView.layer addAnimation:_videoItem.decorder.animation forKey:nil];
            
        }
    });
}

-(CGFloat)getCellHeight:(DFVideoLineItem *)item
{
    if (item.attrText == nil) {
        item.attrText  = [item.text expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    CGFloat height = [super getCellHeight:item];
    
    return height+textSize.height + VideoHeight+TextVideoSpace;
    
}

@end

