//
//  NIMPhotosWallEditViewController.m
//  QianbaoIM
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMPhotosWallEditViewController.h"
#import "JFImagePickerController.h"
//#import "UIProgressView+AFNetworking.h"
#import "NIMProgressImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface NIMPhotosWallEditViewController ()<JFImagePickerDelegate>
@property(nonatomic,retain)UIView *viewsContainer;


@end

@implementation NIMPhotosWallEditViewController
{
    float viewW;
    float viewH;
    
    float imageViewW ;
    float imageViewH ;
    float margin;
    
    BOOL isUploading;
    
    UIView *defaultAddView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.localImageUrls = @[].mutableCopy;;
    [self.localImageUrls addObjectsFromArray:self.imageUrls];
    self.ablumPhotos = @[].mutableCopy;
    
    viewW = [UIScreen mainScreen].bounds.size.width;
    imageViewW = (viewW- 8)/3;
    imageViewH = imageViewW;
    margin = 4;
    
    self.viewsContainer = [[UIView alloc]init];
    self.viewsContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewsContainer];
    [self.viewsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.bottom.equalTo(@(0));
    }];
    
    [self qb_setTitleText:@"编辑"];
    [self qb_showRightButton:@"使用"];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self getUpdateState]) {
        self.rightButton.alpha = 1;
        self.rightButton.userInteractionEnabled = YES;
    }else{
        self.rightButton.alpha = 0.5;
        self.rightButton.userInteractionEnabled = NO;
    }
    isUploading = FALSE;
}

- (void)showTipsViewWithDalay{
  /*
    [self qb_hideLoadingWithCompleteBlock:^{
        isUploading = FALSE;

    }];
    [self.view showTipsView:@"编辑成功"];
*/
}


- (void)reloadData{
    //清空数据 重新布局
    [[self.viewsContainer subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //加载网络图片
    //
    
    int row = 0;
    int column = 0 ;
    for (int i = 0; i< self.localImageUrls.count; i++) {
        row = i/3;
        column = i%3;
        NIMProgressImageView *imageView = [[NIMProgressImageView alloc]initWithFrame:CGRectMake(column*(imageViewW + margin), 65 + margin  +row*(imageViewH + margin), imageViewW, imageViewH)];
        imageView.userInteractionEnabled = YES;
        imageView.imageUrl = [self.localImageUrls objectAtIndex:i];
        [imageView loadImage];
        imageView.tag = 100 + i;
        UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:imageViewTap];
        [self.viewsContainer addSubview:imageView];
    }
    
    // 加载本地图片
    int ablumBeginIndex = 0;
    int ablumEndIndex = 0;
    if (self.localImageUrls.count) {
        ablumBeginIndex = (int)self.localImageUrls.count;
    }
    if (self.ablumPhotos.count) {
        ablumEndIndex = ablumBeginIndex + (int)self.ablumPhotos.count;
    }
    for (int i = ablumBeginIndex; i< ablumEndIndex; i++) {
        row = i/3;
        column = i%3;
        NIMProgressImageView *imageView = [[NIMProgressImageView alloc]initWithFrame:CGRectMake(column*(imageViewW + margin), 65 + margin +row*(imageViewH + 4), imageViewW, imageViewH)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        imageView.image = [self.ablumPhotos objectAtIndex:i - self.localImageUrls.count];
        UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:imageViewTap];
        [self.viewsContainer addSubview:imageView];
    }
    
    if (self.viewsContainer.subviews.count>0 && self.viewsContainer.subviews.count != 9) {
        //添加加号：
        int addBeginIndex = 0;
        if (ablumEndIndex != 0) {
            addBeginIndex = ablumEndIndex;
        }else if(ablumBeginIndex != 0){
            addBeginIndex = ablumBeginIndex;
        }
        row = addBeginIndex/3;
        column = addBeginIndex%3;
        UIImageView *addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(column*(imageViewW + margin), 65 + margin +row*(imageViewH + 4), imageViewW, imageViewH)];
        addImageView.userInteractionEnabled = YES;
        addImageView.image = [UIImage imageNamed:@"btn_addpic"];
        UITapGestureRecognizer *addImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addIMageViewTap:)];
        [addImageView addGestureRecognizer:addImageViewTap];
        [self.viewsContainer addSubview:addImageView];
    }else if (self.viewsContainer.subviews.count == 0){
        [self getDefaultAddView];
    }
    
    // 更新 右上角发送
    
    if ([self getUpdateState]) {
        self.rightButton.alpha = 1;
        self.rightButton.userInteractionEnabled = YES;
    }else{
        self.rightButton.alpha = 0.5;
        self.rightButton.userInteractionEnabled = NO;
    }
    
    
    
}


- (void)qb_rightButtonAction
{
    if(self.ablumPhotos.count <= 0 && self.localImageUrls.count <=0 && self.imageUrls.count<=0){
        //[self.view showTipsView:@"当前没有照片上传"];
        return;
    }
    isUploading = TRUE;
    [self qb_showLoading];
    NSMutableArray *upLoadPhotosUrls = @[].mutableCopy;
    if (self.localImageUrls.count) {
        [upLoadPhotosUrls addObjectsFromArray:self.localImageUrls];
    }
    NSMutableArray *images = @[].mutableCopy;
    if (self.ablumPhotos.count) {
        images = [[NSMutableArray alloc]initWithArray:self.ablumPhotos];
        // 上传qiqiu
        /*
        [[NIMManager sharedImManager]nUploadImages:images completeBlock:^(NSArray *items) {
            if([items count] > 0 )
            {
                // URL 上传自己服务器，f
                // 返回URLS 设置imageURL，更新localimageURL 更新图片墙
                [upLoadPhotosUrls addObjectsFromArray:items];
                [self uploadPhotoUrls:upLoadPhotosUrls];
            }
            else
            {
                [self qb_hideLoadingWithCompleteBlock:^{
                    [self.view showTipsView:@"编辑失败，请重新编辑"];
                    isUploading = FALSE;

                }];
            }
        }];
        */
    }else{
        [self uploadPhotoUrls:upLoadPhotosUrls];
    }
}

-(void)uploadPhotoUrls:(NSMutableArray *)photoUrls{

    NSMutableString* muStr = [NSMutableString stringWithFormat:@""];
    [photoUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muStr appendString:obj];
        [muStr appendString:@","];
    }];
     NSString *imgurlStr = @"";
    if (![muStr isEqualToString:@""]) {
        imgurlStr= [muStr substringToIndex:muStr.length - 1];
    }
//    NSMutableDictionary *param = @{@"imgurl":imgurlStr}.mutableCopy;
//    [[NIMManager sharedImManager] qb_httpRequestMethod:HttpMethodPost url:SERVERURL_uploadPhoto parameters:param completeBlock:^(id object, NIMResultMeta *result) {
//        
//        if (result ==nil ) {
//            // 更新界面
//            self.imageUrls = [object objectForKey:@"doorlist"];
//            [self.localImageUrls removeAllObjects];
//            [self.localImageUrls addObjectsFromArray:self.imageUrls];
//            if(self.ablumPhotos.count){
//                [self.ablumPhotos removeAllObjects];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                for (UIView *subView in self.viewsContainer.subviews) {
//                    if (subView.class == [NIMProgressImageView class]) {
//                        NIMProgressImageView *proImageView = (NIMProgressImageView *)subView;
//                        if (proImageView.progressView.hidden == NO) {
//                            [proImageView finishUpload];
//                        }
//                    }
//                }
//                [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.2];
//                [self performSelector:@selector(showTipsViewWithDalay) withObject:nil afterDelay:1.2];
//
//          
//            });
//
//        }else if(result){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self qb_hideLoadingWithCompleteBlock:^{
//                    [self.view showTipsNIMResultMeta:result];
//
//                }];
//                isUploading = FALSE;
//
//            });
//            
//            
//        }
//    }];
}



- (void)qb_back{
    //设置图片墙数据
    if (isUploading == TRUE) {
        return ;
    }
    
    if ([self getUpdateState]) {
        NIMRIButtonItem * cancelItem = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
            
        }];
        NIMRIButtonItem * okItem      = [NIMRIButtonItem itemWithLabel:@"确定" action:^{
            NIMPhotosWallPreviewViewController *target = nil;
            for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                if ([controller isKindOfClass:[NIMPhotosWallPreviewViewController class]]) { //这里判断是否为你想要跳转的页面
                    target = (NIMPhotosWallPreviewViewController *)controller;
                    break;
                }
            }
            if (target.class == NIMPhotosWallPreviewViewController.class) {
                
                
                NSMutableArray * thumbImageUrls  =@[].mutableCopy;
                for (NSString *imageUrl in self.imageUrls) {
                    [thumbImageUrls addObject:[NSString stringWithFormat:@"%@/%@",imageUrl,@"200"]];
                }
                target.imagesUrls = self.imageUrls;
                target.thumbImageUrls = thumbImageUrls;
                target.selectedIndex = 0;
                [target reloadData];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithNimTitle:nil message:@"确定放弃使用么" cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
        
        [alert show];

    }else{
        NIMPhotosWallPreviewViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[NIMPhotosWallPreviewViewController class]]) { //这里判断是否为你想要跳转的页面
                target = (NIMPhotosWallPreviewViewController *)controller;
                break;
            }
        }
        if (target.class == NIMPhotosWallPreviewViewController.class) {
            NSMutableArray * thumbImageUrls  =@[].mutableCopy;
            for (NSString *imageUrl in self.imageUrls) {
                [thumbImageUrls addObject:[NSString stringWithFormat:@"%@/%@",imageUrl,@"200"]];
            }
            target.imagesUrls = self.imageUrls;
            target.thumbImageUrls = thumbImageUrls;
            [target.localImages removeAllObjects];

            if (!target.imagesUrls.count) {
                //jpg
                target.localImages = @[IMGGET(@"feedHome")].mutableCopy;
            }
            target.selectedIndex = 0;
            [target reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)imageViewTap:(UITapGestureRecognizer *)gesture{
    int selectedIndex = gesture.view.tag - 100;
    NIMPhotosWallPreviewViewController *ct = [[NIMPhotosWallPreviewViewController alloc]init];
    NSMutableArray * thumbImageUrls  =@[].mutableCopy;
    for (NSString *imageUrl in self.imageUrls) {
        [thumbImageUrls addObject:[NSString stringWithFormat:@"%@/%@",imageUrl,@"200"]];
    }
    ct.imagesUrls = self.localImageUrls;
    ct.thumbImageUrls = thumbImageUrls;
    ct.localImages = self.ablumPhotos;
    
    ct.rightBtType = _ScanDeleteType;
    ct.rightBtText = @"删除";
    ct.selectedIndex = selectedIndex;
    ct.showBack = YES;
    ct.delegate = self;
    [self.navigationController pushViewController:ct animated:YES];
}

#pragma mark - delete delegate
- (void)resetLayoutWithUrls:(NSMutableArray *)urls images:(NSMutableArray *)images{
    self.localImageUrls = urls;
    self.ablumPhotos= images;
    [self reloadData];
}

- (void)addIMageViewTap:(UITapGestureRecognizer *)gesture{
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

    if(author ==ALAuthorizationStatusAuthorized || author == ALAuthorizationStatusNotDetermined)
    {
        if (self.viewsContainer.subviews.count == 10) {
          //  [self.view showTipsView:@"最多可以上传9张图片"];
            return;
        }
        [JFImagePickerController setMaxCount:9 -self.localImageUrls.count + self.ablumPhotos.count];
        JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
        picker.pickerDelegate = self;
        
        [self.navigationController presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-照片\"中允许访问照片。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    

}

#pragma mark NIMQBChooseImageViewControllerDelegate

-(void)imagePickerDidFinished:(JFImagePickerController *)picker
{
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *oriImage = [UIImage imageWithCGImage:imageRef];
            [self.ablumPhotos addObject:oriImage];

            
        }];
    }
    [self reloadData];
    [self imagePickerDidCancel:picker];
}

-(void)imagePickerDidCancel:(JFImagePickerController *)picker
{
    [self updateViewConstraints];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

//相比原来数据是否更新
- (BOOL)getUpdateState{
    BOOL updateState = false;
    if (self.ablumPhotos.count || self.imageUrls.count != self.localImageUrls.count) {
        updateState = true;
    }
    return updateState;
}


- (void)getDefaultAddView{
    defaultAddView = [[UIView alloc]init];
    [self.viewsContainer addSubview:defaultAddView];
    
    [defaultAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewsContainer.mas_top).offset(80+ 64);
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.equalTo(@(230));
    }];
    
    UIImageView *baoEr= [[UIImageView alloc]init];
    [self.viewsContainer addSubview:baoEr];
    baoEr.image = [UIImage imageNamed:@"icon_baoer"];
    [baoEr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(defaultAddView.mas_top).offset(10);
        make.centerX.equalTo(@(defaultAddView.center.x));
        make.width.equalTo(@(94));
        make.height.equalTo(@(85));
    }];
    
    UILabel *alert01= [[UILabel alloc]init];
    alert01.text = @"Hi,喵了个咪";
    alert01.textAlignment = NSTextAlignmentCenter;
    alert01.font = [UIFont systemFontOfSize:14];
    [self.viewsContainer addSubview:alert01];
    [alert01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baoEr.mas_bottom).offset(10);
        make.centerX.equalTo(@(defaultAddView.center.x));
        make.width.equalTo(self.viewsContainer.mas_width);
        make.height.equalTo(@(20));
    }];
    
    UILabel *alert02= [[UILabel alloc]init];
    alert02.text = @"您还没有上传照片哦";
    alert02.textAlignment = NSTextAlignmentCenter;
    alert02.font = [UIFont systemFontOfSize:14];
    [self.viewsContainer addSubview:alert02];
    [alert02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert01.mas_bottom).offset(0);
        make.centerX.equalTo(@(defaultAddView.center.x));
        make.width.equalTo(self.viewsContainer.mas_width);
        make.height.equalTo(@(20));
    }];
    
    UIButton *addBt= [[UIButton alloc]init];
    addBt.layer.cornerRadius = 2;
    addBt.layer.masksToBounds = YES;
    addBt.layer.borderWidth = 0.5;
    addBt.layer.borderColor = COLOR_RGBA(249, 46, 33, 1).CGColor;
    UITapGestureRecognizer *addImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addIMageViewTap:)];
    [addBt addGestureRecognizer:addImageViewTap];
    addBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBt setTitle:@"上传照片" forState:UIControlStateNormal];
    [addBt setTitleColor:COLOR_RGBA(249, 46, 33, 1)forState:UIControlStateNormal];
    [self.viewsContainer addSubview:addBt];
    [addBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert02.mas_bottom).offset(40);
        make.centerX.equalTo(@(defaultAddView.center.x));
        make.width.equalTo(@(140));
        make.height.equalTo(@(35));
    }];

    
    
    

    
    
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
