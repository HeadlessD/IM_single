//
//  NIMPhotosWallEditViewController.h
//  QianbaoIM
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMViewController.h"
#import "NIMPhotosWallPreviewViewController.h"
@interface NIMPhotosWallEditViewController : NIMViewController<NIMPhotosWallPreviewViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray   *imageUrls;      //加载图片地址
@property (nonatomic, strong) NSMutableArray   *localImageUrls; //用于操作本地的带有URL的imageview，临时保存imageUrls
@property (nonatomic ,strong) NSMutableArray   *ablumPhotos;    //本地图片


@end
