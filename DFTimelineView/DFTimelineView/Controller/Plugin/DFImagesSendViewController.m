//
//  DFImagesSendViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "NIMMomentsManager.h"
#import "NIMManager.h"

#import "NIMSelectBlackListVC.h"
#import "DFModifyViewController.h"

#import "ZLPhotoActionSheet.h"
#import "ZLPhotoManager.h"
#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7

@interface DFImagesSendViewController()<DFPlainGridImageViewDelegate,NIMSelectBlackListVCDelegate,DFModifyViewControllerDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) UILabel *placeholder;

@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UILabel *modifyL;


@property (nonatomic, strong) DFPlainGridImageView *gridView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) DFTextImageLineItem *textImageItem;
@property (nonatomic, assign) Moments_Priv_Type type;
@property (nonatomic, strong) NSString *list;

@end

@implementation DFImagesSendViewController

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        if (images != nil) {
            [_images addObjectsFromArray:images];
            [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
        }
    }
    return self;
}

- (void)dealloc
{
    _textImageItem = nil;
    [_mask removeGestureRecognizer:_panGestureRecognizer];
    [_mask removeGestureRecognizer:_tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _type = Moments_Priv_Type_Pub;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSendArticle:) name:NC_SEND_ARTICLE object:nil];
    
}

-(void) initView
{
    
    self.view.backgroundColor = COLOR_RGB(237, 237, 237);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat x, y, width, heigh;
    x=0;
    y=74;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    //_contentView.layer.borderColor = [UIColor redColor].CGColor;
    //_contentView.layer.borderWidth =2;
    [self.view addSubview:_contentView];
    
    //placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(x+5, y+5, 150, 25)];
    _placeholder.text = @"这一刻的想法...";
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.enabled = NO;
    [self.view addSubview:_placeholder];
    
    
    _gridView = [[DFPlainGridImageView alloc] initWithFrame:CGRectZero];
    _gridView.delegate = self;
    [self.view addSubview:_gridView];
    
    
    _mask = [[UIView alloc] initWithFrame:self.view.bounds];
    _mask.backgroundColor = [UIColor clearColor];
    _mask.hidden = YES;
    [self.view addSubview:_mask];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_tapGestureRecognizer];
    [self refreshGridImageView];
}

-(void) refreshGridImageView
{
    CGFloat x, y, width, heigh;
    x=10;
    y = CGRectGetMaxY(_contentView.frame)+10;
    width  = ImageGridWidth;
    heigh = [DFPlainGridImageView getHeight:_images maxWidth:width];
    _gridView.frame = CGRectMake(x, y, width, heigh);
    [_gridView updateWithImages:_images];
    
    CGFloat btnY = heigh==0?y:y+heigh+10;
    self.modifyBtn.frame = CGRectMake(0, btnY, self.view.frame.size.width, 50);
    self.modifyL.frame = CGRectMake(SCREEN_WIDTH-110, btnY, 100, 50);
}

-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"取消" selector:@selector(cancel) target:self];
}

-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem text:@"发送" selector:@selector(send) target:self];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) send
{
    if (IsStrEmpty(_contentView.text) && _images.count == 0) {
        [MBTip showTipsView:@"请输入这一刻的想法" atView:self.view];
        return;
    }
    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
    _textImageItem = [[NIMMomentsManager sharedInstance] createTextImage:_contentView.text images:_images];
    _textImageItem.priType = _type;
    if (_type == Moments_Priv_Type_White) {
        _textImageItem.whiteList = _list;
    }else if (_type == Moments_Priv_Type_Black) {
        _textImageItem.blackList = _list;
    }
    NSInteger count = _images.count-1;
    for (int i=0; i<count; i++) {
        // 创建信号量
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
//            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[NIMManager sharedImManager] uploadArticle:_images[i] articleId:_textImageItem.itemId index:i completeBlock:^(id object, NIMResultMeta *result) {
                if (object) {
                    NSString *url = _IM_FormatStr(@"%@/%@",SERVER_FIM_HTTP,[object objectForKey:@"url"]);
                    [images addObject:url];
                    NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:url]];
                    [[DFFileManager sharedInstance] saveFileToLocal:filePath url:url];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                // 发送信号量
                 dispatch_group_leave(group);
            }];
            // 在请求成功之前等待信号量
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }

    dispatch_group_notify(group, queue, ^{
        if (images.count>0) {
            _textImageItem.srcImages = images;
            _textImageItem.thumbImages = images;
            _textImageItem.content = [images componentsJoinedByString:@"#"];
        }
        [[NIMMomentsManager sharedInstance] sendMomentsArticleRQ:_textImageItem];
    });
    
    
}

-(void)recvSendArticle:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
            return;
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(onSendTextImageItem:)]) {
                int64_t itemId = [object longLongValue];
                if (_textImageItem.itemId == itemId) {
                    [_images removeLastObject];
                    [_delegate onSendTextImageItem:_textImageItem];
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
       [MBTip showError:FAILDMESSAGE toView:nil];
    }
}


-(void) onPanAndTap:(UIGestureRecognizer *) gesture
{
    _mask.hidden = YES;
    [_contentView resignFirstResponder];
}



#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeholder.hidden = YES;
    }else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholder.hidden = NO;
        
    }
//    if ([text isEqualToString:@"\n"]){
//        _mask.hidden = YES;
//        [_contentView resignFirstResponder];
//        if (range.location == 0)
//        {
//            _placeholder.hidden = NO;
//        }
//        return NO;
//    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _mask.hidden = NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _mask.hidden = YES;
}

#pragma mark - DFPlainGridImageViewDelegate

-(void)onClick:(NSUInteger)index
{
    
    if (_images.count <= 9 && index == _images.count-1) {
        [self chooseImage];
    }else{
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        NSMutableArray *photos = [NSMutableArray array];
        NSUInteger count;
        if (_images.count > 9)  {
            count = 9;
        }else{
            count = _images.count - 1;
        }
        for (int i=0; i<count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = [_images objectAtIndex:i];
            [photos addObject:photo];
        }
        browser.photos = photos;
        browser.currentPhotoIndex = index;
        
        [browser show];
        
    }
}


-(void)onLongPress:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger i){
        switch (i) {
            case 0:
                [_images removeObjectAtIndex:index];
                [self refreshGridImageView];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"删除", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];
    
}

-(void) chooseImage
{
    
    
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    
    [sheetView show];
    
    
}


-(void) takePhoto
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_pickerController animated:YES completion:nil];
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.allowEditImage = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowMixSelect = NO;
    actionSheet.configuration.allowDragSelect = YES;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = NO;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 0;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount = 9-_images.count+1;
    actionSheet.configuration.navBarColor = kRGB(34, 34, 34);
    
    actionSheet.configuration.bottomBtnsNormalTitleColor = kRGB(34, 34, 34);
    
    //单选模式是否显示选择按钮
    //    actionSheet.configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    //    actionSheet.configuration.editAfterSelectThumbnailImage = self.editAfterSelectImageSwitch.isOn;
    //是否保存编辑后的图片
    //    actionSheet.configuration.saveNewImageAfterEdit = NO;
    //设置编辑比例
    //    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
    //是否在已选择照片上显示遮罩层
    //    actionSheet.configuration.showSelectedMask = self.maskSwitch.isOn;
    //颜色，状态栏样式
    //    actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
    //    actionSheet.configuration.navBarColor = [UIColor orangeColor];
    //    actionSheet.configuration.navTitleColor = [UIColor blackColor];
    //    actionSheet.configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
    //    actionSheet.configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
    //    actionSheet.configuration.bottomViewBgColor = [UIColor blackColor];
    //    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
    //是否允许框架解析图片
    //    actionSheet.configuration.shouldAnialysisAsset = self.allowAnialysisAssetSwitch.isOn;
    //框架语言
    //    actionSheet.configuration.languageType = self.languageSegment.selectedSegmentIndex;
    //自定义多语言
    //    actionSheet.configuration.customLanguageKeyValue = @{@"ZLPhotoBrowserCameraText": @"没错，我就是一个相机"};
    
    //是否使用系统相机
    //    actionSheet.configuration.useSystemCamera = YES;
    //    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    //    actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
    //    actionSheet.configuration.allowRecordVideo = NO;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        [strongSelf anialysisAssets:assets original:isOriginal];
        
    }];
    
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    
    return actionSheet;
}

- (void)anialysisAssets:(NSArray<PHAsset *> *)assets original:(BOOL)original
{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    //该hud自动15s消失，请使用自己项目中的hud控件
    [hud show];
    
    zl_weakify(self);
    
    if (assets && assets.count>0) {
        PHAsset *asset = assets.firstObject;
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            
        } else if (asset.mediaType == PHAssetMediaTypeImage) {
            [ZLPhotoManager anialysisAssets:assets original:original completion:^(NSArray<UIImage *> *images) {
                zl_strongify(weakSelf);
                [hud hide];
                //        strongSelf.arrDataSources = images;
                //        [strongSelf.collectionView reloadData];
                NSLog(@"%@", images);
                for (UIImage *image in images) {
                    [_images insertObject:image atIndex:(_images.count-1)];
                }
                
                [strongSelf refreshGridImageView];
            }];
        }
        
    }
    
    
}

-(void) pickFromAlbum
{
    ZLPhotoActionSheet *a = [self getPas];
    [a showPhotoLibrary];
    /*
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10-_images.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
     */
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count-1)];
    }
    
    [self refreshGridImageView];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_images insertObject:image atIndex:(_images.count-1)];
    
    [self refreshGridImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DFModifyViewControllerDelegate

-(void)modifyViewController:(DFModifyViewController *)viewController didSelectPriType:(Moments_Priv_Type)type users:(NSArray *)users
{
    NSArray *arr = @[@"公开",@"私密",@"部分可见",@"不给谁看"];
    _type = type;
    _list = [users componentsJoinedByString:@","];
    self.modifyL.text = arr[_type-1];
}

-(void)modify
{
    DFModifyViewController *blackList = [[DFModifyViewController alloc] init];
    blackList.delegate = self;
    blackList.index = _type-1;
    [self.navigationController pushViewController:blackList animated:YES];
}

-(UIButton *)modifyBtn
{
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_modifyBtn setTitle:@"谁可以看" forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _modifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _modifyBtn.backgroundColor = [UIColor whiteColor];
        _modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _modifyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_modifyBtn addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_modifyBtn];
    }
    return _modifyBtn;
}

-(UILabel *)modifyL
{
    if (!_modifyL) {
        _modifyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _modifyL.font = [UIFont systemFontOfSize:15];
        _modifyL.backgroundColor = [UIColor whiteColor];
        _modifyL.text = @"全部";
        _modifyL.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_modifyL];
    }
    return _modifyL;
}

@end
