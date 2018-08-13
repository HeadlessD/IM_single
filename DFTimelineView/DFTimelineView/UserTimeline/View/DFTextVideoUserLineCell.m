//
//  DFTextVideoUserLineCell.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/24.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "DFTextVideoUserLineCell.h"
#import "ZLDefine.h"
#import "UIImage+NIMEffects.h"
#define TextImageCellHeight 70

#define ImageTxtPadding 10

#define TxtSinglePadding 9

@interface DFTextVideoUserLineCell()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *txtLabel;

@property (nonatomic, strong) UIImageView *playView;

@end

@implementation DFTextVideoUserLineCell

#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
    }
    return self;
}


-(void) initSubView
{
    
    if (_coverView == nil) {
        _coverView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverView.backgroundColor = [UIColor lightGrayColor];
        [self.bodyView addSubview:_coverView];
    }
    
    if (_txtLabel == nil) {
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _txtLabel.font = [UIFont systemFontOfSize:14];
        _txtLabel.numberOfLines = 3;
        [self.bodyView addSubview:_txtLabel];
    }
    
    if (_playView == nil) {
        _playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _playView.image = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"playVideo")];
        _playView.hidden = YES;
        [_coverView addSubview:_playView];
    }
}


-(void) updateWithItem:(DFTextVideoUserLineItem *) item
{
    [super updateWithItem:item];
    
    [self updateBodyWithHeight:TextImageCellHeight];
    
    
    CGFloat x, y, width, height;
    
    x = 0;
    y = 0;
    width= TextImageCellHeight;
    height = width;
    _coverView.frame  = CGRectMake(x, y, width, height);
    _playView.center  = CGPointMake(_coverView.center.x, height*0.5);
    if (item.cover != nil) {
        _coverView.hidden = NO;
        _playView.hidden = NO;
        [_coverView sd_setImageWithURL:[NSURL URLWithString:item.cover]];
    }else{
        _coverView.hidden = YES;
        _playView.hidden = YES;
    }
    
    if (item.cover != nil) {
        x = CGRectGetMaxX(_coverView.frame) + ImageTxtPadding;
        width = CGRectGetWidth(self.bodyView.frame) - x;
        height = CGRectGetHeight(self.bodyView.frame) - 20;
        self.bodyView.backgroundColor = [UIColor clearColor];
    }else{
        x = TxtSinglePadding;
        y = TxtSinglePadding;
        width = CGRectGetWidth(self.bodyView.frame) - 2*x;
        height = CGRectGetHeight(self.bodyView.frame) - 2*y;
        self.bodyView.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
    }
    
    
    _txtLabel.frame = CGRectMake(x, y, width, height);
    _txtLabel.text = item.text;
    [_txtLabel sizeToFit];
    
    BOOL isCover = YES;
    NSString *extension = [item.cover pathExtension];
    NSString *realExtension = @"";
    if ([extension isEqualToString:@"vo"]) {
        realExtension = @"mov";
        isCover = NO;
    } else {
        realExtension = @"jpg";
        isCover = YES;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@%@.%@",DF_CACHEPATH, [DFToolUtil md5:item.cover],realExtension];
    
    BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
    if (isExist) {
        if (isCover) {
            _coverView.image = [UIImage imageWithContentsOfFile:filePath];
        } else {
            _coverView.image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:filePath]];
        }
    } else {
        if (isCover) {
            [_coverView sd_setImageWithURL:[NSURL URLWithString:item.cover]];
        }
//        [[DFFileManager sharedInstance] saveFileToLocal:filePath url:item.cover];
//        [DFFileManager sharedInstance].saveBlock = ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (isCover) {
//                    _coverView.image = [UIImage imageWithContentsOfFile:filePath];
//                } else {
//                    _coverView.image = [UIImage nim_getVideoPreViewImage:[NSURL fileURLWithPath:filePath]];
//                }
//            });
//        };
    }
    
}



-(CGFloat) getCellHeight:(DFTextVideoUserLineItem *) item
{
    return [super getCellHeight:item] + TextImageCellHeight;
}
@end
