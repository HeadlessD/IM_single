//
//  DFTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTimeLineViewController.h"
#import "DFLineCellManager.h"

#import "DFBaseLineCell.h"
#import "DFLineCommentItem.h"
#import "DFLineCommentItem.h"
#import "CommentInputView.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"


#import "DFImagePreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ZHSmallVideoController.h"
#import "UIImage+NIMEffects.h"
#import "DFVideoSendViewController.h"

#import "ZLPhotoActionSheet.h"
#import "ZLPhotoManager.h"
@interface DFTimeLineViewController ()<DFLineCellDelegate, CommentInputViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DFImagesSendViewControllerDelegate,DFVideoCaptureControllerDelegate, DFImagePreviewViewControllerDelegate,ZHSmallVideoControllerDelegate,DFVideoSendViewControllerDelegate>

//@property (nonatomic, strong) NSMutableArray *items;

//@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableDictionary *commentDic;


@property (strong, nonatomic) CommentInputView *commentInputView;


@property (assign, nonatomic) long long currentItemId;

@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) ZHSmallVideoController *videoController;

@end

@implementation DFTimeLineViewController


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [[MMPopupWindow sharedWindow] cacheWindow];
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
        sheetConfig.defaultTextCancel = @"取消";
        
//        _items = [NSMutableArray array];
        
//        _itemDic = [NSMutableDictionary dictionary];
        
        _commentDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSendComment:) name:NC_SEND_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeleteComment:) name:NC_DELETE_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeleteArticle:) name:NC_DELETE_ARTICLE object:nil];

    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight =0;
        self.tableView.estimatedSectionHeaderHeight =0;
        self.tableView.estimatedSectionFooterHeight =0;
    }
    [self initCommentInputView];
    
}






-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_commentInputView addNotify];
    
    [_commentInputView addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_commentInputView removeNotify];
    
    [_commentInputView removeObserver];
}











-(void) initCommentInputView
{
    if (_commentInputView == nil) {
        _commentInputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _commentInputView.hidden = YES;
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - BarButtonItem


-(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *item = [UIBarButtonItem icon:@"icon_camera" selector:@selector(onClickCamera:) target:self];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressCamera:)];
    [item.customView addGestureRecognizer:recognizer];
    return item;
}

-(void) onLongPressCamera:(UIGestureRecognizer *) gesture
{
    DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:nil];
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}



-(void) onClickCamera:(id) sender
{
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self captureViedo];
                break;
            case 1:
                [self takePhoto];
                break;
            case 2:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"小视频", MMItemTypeNormal, block),
      MMItemMake(@"拍照", MMItemTypeNormal, block),
      MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    
    [sheetView show];
}


-(void) captureViedo
{
    _videoController = [[ZHSmallVideoController alloc] initWithDelegate:self];
    [self presentViewController:_videoController animated:YES completion:^{
        
    }];

}


-(void) takePhoto
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_pickerController animated:YES completion:nil];
}

-(void) pickFromAlbum
{
    ZLPhotoActionSheet *a = [self getPas];
    [a showPhotoLibrary];
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    imagePickerVc.allowPickingVideo = YES;
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.allowEditImage = NO;
    actionSheet.configuration.allowEditVideo = YES;
    actionSheet.configuration.maxEditVideoTime = 6;
    actionSheet.configuration.allowMixSelect = NO;
    actionSheet.configuration.allowDragSelect = YES;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = NO;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 0;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount = 9;
    //设置允许选择的视频最大时长
    actionSheet.configuration.maxVideoDuration = 6;
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
            [self getVideoFromPHAsset:asset Complete:^(NSData *data, NSString *result) {
                zl_strongify(self);
                [hud hide];
                NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:result];
                NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
                NSLog(@"视频存在本地的路径：%@", url);
                UIImage *image = [UIImage nim_getVideoPreViewImage:url];
                DFVideoSendViewController *controller = [[DFVideoSendViewController alloc] init];
                controller.delegate = strongSelf;
                controller.screenShot = image;
                controller.localPath = url.path;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                [strongSelf presentViewController:navController animated:YES completion:nil];
            }];
        } else if (asset.mediaType == PHAssetMediaTypeImage) {
            [ZLPhotoManager anialysisAssets:assets original:original completion:^(NSArray<UIImage *> *images) {
                zl_strongify(weakSelf);
                [hud hide];
                //        strongSelf.arrDataSources = images;
                //        [strongSelf.collectionView reloadData];
                NSLog(@"%@", images);
                DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:images];
                controller.delegate = self;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                [strongSelf presentViewController:navController animated:YES completion:nil];
            }];
        }
        
    }
    
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [NIMMomentsManager sharedInstance].moment_arr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance].moment_arr objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    return [typeCell getReuseableCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance].moment_arr objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }
    

    cell.delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
//    [self genLikeAttrString:item];
//    [self genCommentAttrString:item];
    [cell updateWithItem:item forRow:indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.refreshBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (item.isRefresh) {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        });
    };
    return cell;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击所有cell空白地方 隐藏toolbar
    NSInteger rows =  [tableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell hideLikeCommentToolbar];
    }
}


#pragma mark - Method

-(DFBaseLineCell *) getCell:(Class)itemClass
{
    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}

-(void)addItem:(DFBaseLineItem *)item
{
//    [self insertItem:item index:_items.count];
}

-(void) addItemTop:(DFBaseLineItem *) item
{
    [self insertItem:item index:0];
}

-(void) insertItem:(DFBaseLineItem *) item index:(NSUInteger)index
{
//    [self genLikeAttrString:item];
//    [self genCommentAttrString:item];
    
//    [_items insertObject:item atIndex:index];
    
    
//    [[NIMMomentsManager sharedInstance].moment_dict setObject:item forKey:[NSNumber numberWithLongLong:item.itemId]];
    
    [self.tableView reloadData];
}


-(void)deleteItem:(long long)itemId
{
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
    [[NIMMomentsManager sharedInstance].moment_arr removeObject:item];
    [[NIMMomentsManager sharedInstance].moment_dict removeObjectForKey:[NSNumber numberWithLongLong:item.itemId]];
}


-(void)addLikeItem:(DFLineCommentItem *)likeItem itemId:(long long)itemId
{
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
    likeItem.articleId = item.itemId;
    likeItem.articleUserId = item.userId;
    [item.likes insertObject:likeItem atIndex:0];
    item.likesStr = nil;
    item.cellHeight = 0;
    [[NIMMomentsManager sharedInstance] sendMomentsCommentAddRQ:likeItem];
//    [self genLikeAttrString:item];
//
//    [self.tableView reloadData];
}


-(void)addCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId

{
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
    [item.comments addObject:commentItem];
    
    if (replyCommentId > 0) {
        DFLineCommentItem *replyCommentItem = [[NIMMomentsManager sharedInstance] getCommentItem:replyCommentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
    }
    commentItem.articleId = item.itemId;
    commentItem.articleUserId = item.userId;
    item.cellHeight = 0;
    [[NIMMomentsManager sharedInstance] genCommentAttrString:item];
    [self.tableView reloadData];
}






#pragma mark - DFLineCellDelegate

-(void)onClickDelete:(int64_t)itemId
{
    UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该朋友圈" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
        if (item) {
            [[NIMMomentsManager sharedInstance] deleteMomentsArticleRQ:item];
        }
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [netAlert addAction:cancle];
    [netAlert addAction:nAction];
    [self presentViewController:netAlert animated:YES completion:^{
    }];
    
}


-(void)onComment:(long long)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
}


-(void)onLike:(int64_t)itemId
{
    
}

-(void)onClickUser:(NSUInteger)userId
{
    
}


-(void)onClickComment:(long long)commentId itemId:(long long)itemId
{
    DFLineCommentItem *comment = [[NIMMomentsManager sharedInstance] getCommentItem:commentId];
    if (comment.userId == OWNERID) {
        return;
    }
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    [_commentInputView show];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
    
}

-(void)onDeleteComment:(int64_t)itemId
{
    DFLineCommentItem *item = [[NIMMomentsManager sharedInstance] getCommentItem:itemId];
    if (item) {
        [[NIMMomentsManager sharedInstance] deleteMomentsCommentRQ:item];
    }
}


-(void)onCommentCreate:(long long)commentId text:(NSString *)text
{
    [self onCommentCreate:commentId text:text itemId:_currentItemId];
}


-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    
}




#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:photos];
        controller.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    });
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset
{
    [self getVideoFromPHAsset:asset Complete:^(NSData *data, NSString *result) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:result];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        NSLog(@"视频存在本地的路径：%@", url);
        UIImage *image = [UIImage nim_getVideoPreViewImage:url];
        DFVideoSendViewController *controller = [[DFVideoSendViewController alloc] init];
        controller.delegate = self;
        controller.screenShot = image;
        controller.localPath = url.path;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void (^)(NSData *data,NSString *result))result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, fileName);
                                                             }
//                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:@[image]];
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - DFImagesSendViewControllerDelegate

-(void)onSendTextImageItem:(DFTextImageLineItem *)item
{
    
}

#pragma mark - DFVideoCaptureControllerDelegate
-(void)onCaptureVideo:(NSString *)filePath screenShot:(UIImage *)screenShot
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self onSendVideo:@"" videoPath:filePath screenShot:screenShot];
    });
}


#pragma mark - ZHSmallVideoControllerDelegate

-(void)zh_delegateVideoInLocationUrl:(NSURL *)url
{
    [_videoController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"视频存在本地的路径：%@", url);
    [[DFFileManager sharedInstance] writeVideoToPhotoLibrary:url];
    UIImage *image = [UIImage nim_getVideoPreViewImage:url];
    DFVideoSendViewController *controller = [[DFVideoSendViewController alloc] init];
    controller.delegate = self;
    controller.screenShot = image;
    controller.localPath = url.path;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - DFVideoSendViewControllerDelegate

-(void)onSendTextVideoItem:(DFVideoLineItem *)item
{
    
}


#pragma mark - UIViewControllerPreviewingDelegate

-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:location];
    
    if(indexPath)
    {

        DFBaseLineCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

        if (cell && [cell isKindOfClass:[DFTextImageLineCell class]]) {
            DFTextImageLineCell *imageCell = (DFTextImageLineCell *)cell;
            NSInteger index = [imageCell getIndexFromPoint:location];
            
            DFBaseLineItem *item = [[NIMMomentsManager sharedInstance].moment_arr objectAtIndex:indexPath.row];
            if (item && [item isKindOfClass:[DFTextImageLineItem class]]) {
                DFTextImageLineItem *textItem = (DFTextImageLineItem *) item;
                if (index == -1) {
                    return nil;
                }
                NSString *url  = [textItem.thumbPreviewImages objectAtIndex:index];
                DFImagePreviewViewController *previewController=[[DFImagePreviewViewController alloc] initWithImageUrl:url itemId:item.itemId];
                previewController.delegate = self;
                previewController.preferredContentSize=CGSizeMake(300, 300);
                return previewController;
            }
        }
    }
    return nil;
}
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

-(void)recvSendComment:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            DFLineCommentItem *commentItem = object;
            DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:commentItem.articleId];
            [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
            if (commentItem.commentType == Comment_Type_Like) {
                [[NIMMomentsManager sharedInstance] insertLikeItem:commentItem];
                if (![item.likes containsObject:commentItem]) {
                    [item.likes insertObject:commentItem atIndex:0];
                }
                item.likesStr = nil;
                item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genLikeAttrString:item];
            }else if (commentItem.commentType == Comment_Type_Comment){
                if (![item.comments containsObject:commentItem]) {
                    [item.comments addObject:commentItem];
                }
                item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genCommentAttrString:item];
            }
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}

-(void)recvDeleteComment:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            DFLineCommentItem *commentItem = [[NIMMomentsManager sharedInstance] getCommentItem:[object longLongValue]];
            DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:commentItem.articleId];
            if (commentItem.commentType == Comment_Type_Like) {
                [[NIMMomentsManager sharedInstance] deleteLikeItem:commentItem.userId];
                [item.likes removeObject:commentItem];
                item.likesStr = nil;
                item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genLikeAttrString:item];
            }else if (commentItem.commentType == Comment_Type_Comment){
                [item.comments removeObject:commentItem];
                item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genCommentAttrString:item];
            }
            [[NIMMomentsManager sharedInstance] deleteCommentItem:commentItem.commentId];
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}


-(void)recvDeleteArticle:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            int64_t itemId = [object longLongValue];
            [[NIMMomentsManager sharedInstance] deleteItem:itemId];
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}
@end
