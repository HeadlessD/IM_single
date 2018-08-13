//
//  NIMPhotosWallPreviewViewController.h
//  QianbaoIM
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMViewController.h"
#import "NIMLatestVcardViewController.h"
typedef NS_ENUM(NSInteger, _EditRightBtType) {
    _ScanNoneType,      //右键隐藏
    _ScanEditType,      //右键编辑
    _ScanDeleteType     //右键删除
};

@protocol NIMPhotosWallPreviewViewControllerDelegate<NSObject>
// 编辑后返回图片
- (void)resetLayoutWithUrls:(NSMutableArray *)urls images:(NSMutableArray *)images;
// 选中当前图片
- (void)resetBgImageWithIndex:(int)index imagesUrls:(NSMutableArray *)imageUrls;
@end

@interface NIMPhotosWallPreviewViewController : NIMViewController<VcardForwardDelegate,UIActionSheetDelegate>
@property (nonatomic, assign) NSInteger   selectedIndex;   //当前索引

@property (nonatomic, strong) UIImage     *placeHoderImage;   //默认预加载图片
@property (nonatomic, strong) NSMutableArray  * imagesUrls;     //预览图片urls
@property (nonatomic, strong) NSMutableArray  *thumbImageUrls; //缩图图片地址
@property (nonatomic, strong) NSMutableArray  * localImages;         //预览图片

@property (nonatomic, assign) _EditRightBtType rightBtType;
@property (nonatomic, strong) NSString *rightBtText;       //右键显示内容
@property (nonatomic, strong) NSString *titleText  ;       //标题 , 如果没有则是显示页数。
@property (nonatomic, assign) BOOL showBack;               //是否显示返回按钮，隐藏则点击向上按钮返回
@property (nonatomic, assign) BOOL hidePageCt;               //是否显示返回按钮，隐藏则点击向上按钮返回


@property (nonatomic, weak) id<NIMPhotosWallPreviewViewControllerDelegate>  delegate;    //出发代理方法

- (void)reloadData;


@end
