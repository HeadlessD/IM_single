//
//  NIMScanCodeViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/11/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GTMBase64.h"
#import "NIMChatUIViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NIMGroupVcardVC.h"
//#import "QBHtmlWebViewController.h"
#import "NIMSelfViewController.h"
#import "NIMUserOperationBox.h"
//#import "PublicEntity.h"
//#import "NIMSysPublicInfoViewController.h"
//#import "NIMAllPublicInfoVC.h"
//#import "NIMManager+o2o.h"
//#import "NIMManager.h"
#import "UIAlertView+NIMBlocks.h"
//#import "O2OScanResultBean.h"
//#import "UIImageView+QBWebImage.h"
#import "NetCenter.h"
#import "UIActionSheet+nimphoto.h"

#define kScanWidth 240
#define kCoverColor [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.7]
#define kO2OUrl @"o2o.qbao.com/pay/"
#define kBaoQuanUrl @"http://m.qbao.com/api/v34/o2opay/scanCodeGetBaoQuan"
typedef NS_ENUM(NSInteger, SCAN_MODE) {// 消息内容扩展类型:（1~60为语音时间）
    SCAN_MODE_NO            = 1,  //禁用相机
    SCAN_MODE_YES           = 2,  //相机可用
    SCAN_MODE_TAP_YES       = 3,  //相机需赋权使用
};

@interface NIMScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) UIBarButtonItem* rightItem;
@property (nonatomic, strong) UIImageView* scanImageView;
@property (nonatomic, strong) UIImageView* imageCover;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, assign) SCAN_MODE scan;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation NIMScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if(self.session){
//        [self.session startRunning];
//    }
    
    _isFirst = YES;
    _scan = SCAN_MODE_NO;
    [UIActionSheet nim_canCameraWithYES:^{
        if (_isFirst) {
            _scan = SCAN_MODE_YES;
        }else{
            _scan = SCAN_MODE_TAP_YES;
        }
        [_session stopRunning];
        if (_session.outputs.count > 0)
        {
            for (AVCaptureMetadataOutput *avc in _session.outputs)
            {
                [avc setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];
            }
        }
        if ([NIMSysManager sharedInstance].GetNetStatus != LOGINED) {
            _scan = SCAN_MODE_NO;
        }
        _session = nil;
        if(self.session){
            [self.session startRunning];
        }
    } withNO:^{
        _scan = SCAN_MODE_NO;
    }];
    _isFirst = NO;

    [self qb_setTitleText:@"扫一扫"];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    //[self qb_setNavStyleTheme:THEME_COLOR_TRANSPARENT_WHITE];
    if(self.session){
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _scan==SCAN_MODE_TAP_YES?_scan=SCAN_MODE_YES:_scan;
    [_session stopRunning];
    if (_session.outputs.count > 0)
    {
        for (AVCaptureMetadataOutput *avc in _session.outputs)
        {
            [avc setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];
        }
    }
    
    _session = nil;
    
}

- (void)dealloc
{
    [_session stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:从相册选择图片
- (void)chooseImage:(id)sender{
    [UIActionSheet nim_canPhotoLibraryWithYES:^{
        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
        [self setNeedsStatusBarAppearanceUpdate];
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        
        [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
        imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    } withNO:^{
        
    }];
    
}

//TODO:从相册读取图片
- (NSString*)readInfoFromImage:(UIImage*)image{
    if(image.size.width >500 || image.size.height > 500)
    {
        CGFloat w,h;
        if(image.size.width > 500)
        {
            
            CGFloat k = 500.0 / image.size.width;
            h = image.size.height * k;
            w = 500;
            
        }
        else
        {
            CGFloat k = 500.0 / image.size.height;
            w = image.size.width * k;
            h = 500;
        }
        
        image = [SSIMSpUtil scaleFromImage:image toSize:CGSizeMake(w, h)];
    }
    else
    {
        
    }
    //1. 初始化扫描仪，设置设别类型和识别质量
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    //2. 扫描获取的特征组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    //3. 获取扫描结果
    if (features.count<=0) {
        return nil;
    }
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    NSString *codeString = feature.messageString;
    return codeString;
}

- (void)showError{
    [MBTip showError:@"该二维码无法识别" toView:self.view];
    [self.session startRunning];
}

- (BOOL)isQBHtml:(NSString*)str{
    str = [str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    if([str hasPrefix:@"user.qbao.com/usercenter/promote.html"])return YES;
    if([str hasPrefix:@"m.qbao.com/store/shop.htm?"])return NO;
    if([str hasPrefix:@"a.qbao.com"])return YES;
    if([str hasPrefix:@"qianb.cn"])return YES;
    if([str hasPrefix:@"qba.la"])return YES;
    if([str hasPrefix:@"im.qbao.com"])return YES;
    if([str hasPrefix:@"im.qianbao666.com"])return YES;
    if([str hasPrefix:@"store.qbao.com"])return YES;
    if ([SSIMSpUtil stringA:str containString:@".qbao."]) {
        return YES;
    }
    if ([SSIMSpUtil stringA:str containString:@".qianbao666."]) {
        return YES;
    }
    if([str hasPrefix:[NSString stringWithFormat:@"%@/usercenter/promote.html",SERVER_USER_QB]])return YES;
    return NO;
}

- (void)delayOperate {
    [self.navigationController popViewControllerAnimated:YES];
}
//TODO:解析获取到的字符串
- (void)parseString:(NSString*)str{
    
    BOOL isQBHeml = [self isQBHtml:str];
    
    NSString* baseUrl = str;
    //是否是用户
    NSArray* isUser = [str componentsSeparatedByString:@"user="];
    //是否是群组
    NSArray* isGroup = [str componentsSeparatedByString:@"group="];
    //网页4中方式
    NSArray* tmp = [str componentsSeparatedByString:@"/"];
    if(isUser.count>=2 || isGroup.count>=2){
        tmp = @[].copy;
    }
//    if((tmp.count<2&&isUser.count<2&&isGroup.count<2)||!isQBHeml){
//        NSURL* url = [self smartURLForString:baseUrl];
//        if(url){
//            [self openWeb:url.description];
//            return;
//        }
//        [self showError];
//        return;
//    }
    NIMRIButtonItem* cancel = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
        [self.session startRunning];
    }];
    NIMRIButtonItem* ok = nil;
    if(tmp.count>=2)//从网页扫描的4种情况
    {
        NSString* baseCode = [tmp lastObject];
        NSData *data = [GTMBase64 decodeString:baseCode];
        if(!data){
            NSURL* url = [self smartURLForString:baseUrl];
            if(url){
                [self openWeb:url.description];
                return;
            }
            [self showError];
            return;
        }
        NSString * url = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray* urlArray = [url componentsSeparatedByString:@"/"];
        DBLog(@"%@",urlArray);
        if(urlArray.count <2){
            NSURL* url = [self smartURLForString:baseUrl];
            if(url){
                
                [self openWeb:url.description];
                return;
            }
            [self showError];
            return;
        }
        [NIMBaseUtil playBeep];
        ok = [NIMRIButtonItem itemWithLabel:@"查看" action:^{
            NSString* key = urlArray[0];
            NSString* value = urlArray[1];
            if([key isEqualToString:@"user"])//用户，打开对方聊天界面
            {
                [self showChatView:value.longLongValue];
            }
            else if([key isEqualToString:@"ware"])//商品发布界面
            {
                if([value isEqualToString:@"add"]){
                    //[self showPublicGoods];
                }
                else
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    if([urlArray count] == 6)
                    {
                        [dic setObject:urlArray[1] forKey:urlArray[0]];
                        [dic setObject:urlArray[3] forKey:urlArray[2]];
                        [dic setObject:urlArray[5] forKey:urlArray[4]];

                    }
                    else if([urlArray count] == 4)
                    {
                        [dic setObject:urlArray[1] forKey:urlArray[0]];
                        [dic setObject:urlArray[3] forKey:urlArray[2]];
                    }
                    else if([urlArray count] == 2)
                    {
                        [dic setObject:urlArray[1] forKey:urlArray[0]];
                    }
                    
                }
            }
            else if([key isEqualToString:@"seller"])//商家界面
            {
                [self showChatView:value.longLongValue];
            }
            else if ([key isEqualToString:@"contactPub"])
            {
//                NSString   *thread = [NIMMessageContent combineThreadWithMTPacketType:MTPacketTypePublic fromID:value.doubleValue toID:OWNERID];
//                [self pushThread:thread];
                
            }
            else if ([key isEqualToString:@"contactUser"])
            {
                NSString   *thread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:value.longLongValue];
                
                [self pushThread:thread];
                
            }

            else if([key isEqualToString:@"pub"])//公众号详情
            {
                [self showPublicInfo:value];
            }
        }];
        
    }
    else{
        [NIMBaseUtil playBeep];
        ok = [NIMRIButtonItem itemWithLabel:@"查看" action:^{
            if(isUser.count>=2){
                NSString* suid = isUser.lastObject;
                [self showChatView:suid.longLongValue];
            }
            if(isGroup.count>=2){
                NSString* idInfo = isGroup.lastObject;
                NSArray *tmpArr = [idInfo componentsSeparatedByString:@"_"];
                int64_t groupid = [tmpArr.firstObject longLongValue];
                int64_t inviteId = [tmpArr.lastObject longLongValue];

                [self showGroup:groupid inviteid:inviteId];
            }
        }];
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithNimTitle:@"查看扫描结果" message:nil cancelButtonItem:cancel otherButtonItems:ok, nil];
    [alert show];
}

//显示公众号
- (void)showPublicInfo:(NSString*)publicId{
//    NSString *source = [NSString stringWithFormat:@"%ld",(long)ScanSource];
//    NIMAllPublicInfoVC *vc = [[NIMAllPublicInfoVC alloc]init];
//    vc.publicid= publicId.doubleValue;
//    vc.publicSourceType = source;
//    [self.navigationController pushViewController:vc animated:YES];
}
//打开网址
- (void)openWeb:(NSString*)url{
    
    /*
    [NIMBaseUtil playBeep];
    NIMRIButtonItem* cancel = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
        [self.session startRunning];
    }];
    NSString  *str = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NIMRIButtonItem* ok = [NIMRIButtonItem itemWithLabel:@"查看" action:^{
        NSMutableDictionary* mudic = [[NSMutableDictionary alloc] init];
        [mudic setValue:url forKey:@"url"];
        NSURL *url =[NSURL URLWithString:mudic[@"url"]];

        WEBFILTER_RESULT t_filterResult = [[NIMWebViewFilter shareFilter] filterForUrl:[url absoluteString]  info:nil];
        if (t_filterResult==WEBFILTER_RESULT_BAOGOU_IM)
        {
            
        }
        else
        {

        if([str hasPrefix:@"store.qbao.com"])
        {
            
        }
        else
        {
            
//            QBHtmlWebViewController *htmlWebVC = [[UIStoryboard storyboardWithName:@"NIMChatUI" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMHtmlWebViewController"];
//            [htmlWebVC setHidesBottomBarWhenPushed:YES];
//            htmlWebVC.linkDict = mudic;
//            htmlWebVC.isNotReport = YES;
//            
//            [self.navigationController pushViewController:htmlWebVC animated:YES];
        }
        }

    }];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"查看扫描结果" message:nil cancelButtonItem:cancel otherButtonItems:ok, nil];
    [alert show];
     */
}
//到聊天界面
- (void)showChatView:(int64_t)userid{
//    NSString* thread = [NIMMessageContent combineThreadWithMTPacketType:MTPacketTypePrivate
//                                                              fromID:[NIMManager sharedImManager].loginUserInfo.userId.doubleValue
//                                                                toID:userid];
//    [self pushThread:thread];
            NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

    feedProfileVC.userid = userid;
    feedProfileVC.feedSourceType = ScanSource;
    [self.navigationController pushViewController:feedProfileVC animated:YES];
}
//到群组界面
- (void)showGroup:(int64_t)groupId inviteid:(int64_t)inviteid{

    NIMGroupVcardVC* group = (NIMGroupVcardVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupVcardVC"];
    group.groupid = groupId;
    group.inviteid = inviteid;
    [self.navigationController pushViewController:group animated:YES];

}
//发布商品


//TODO:显示聊天界面
- (void)pushThread:(NSString*)thread{
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    [chatVC setThread:thread];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//扫描获取url
- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
//    NSString *  trimmedStr;
//    NSRange     schemeMarkerRange;
//    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    if([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"])
    {
        result = [NSURL URLWithString:str];
    } else {
        // It looks like this is some unsupported URL scheme.
    }
    if(!result)
    {
        if([str hasPrefix:@"www.baidu.com"]){
            result = [NSURL URLWithString:str];
        }
    }
    
    return result;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //    captureOutput rectForMetadataOutputRectOfInterest:<#(CGRect)#>
    if ([metadataObjects count] >0)
    {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        [self parseString:metadataObject.stringValue.copy];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera
        || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString* codeStr = @"";
    if (image) {
        codeStr = [self readInfoFromImage:image];
    }
    if(codeStr.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBTip showError:@"未发现二维码" toView:[[UIApplication sharedApplication]keyWindow]];
        });
        [self.session startRunning];
    }
    else{
        [self parseString:codeStr.copy];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark getter
- (AVCaptureSession*)session{
    if(!_session){
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if (_scan != SCAN_MODE_NO) {
            [_session addInput:input];
            [_session addOutput:output];
            output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        }
        
        
        
        CGSize size = self.view.bounds.size;
        CGFloat fwidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
        CGRect cropRect = CGRectMake((fwidth-kScanWidth)/2.0, self.view.center.y-kScanWidth/2.0, kScanWidth, kScanWidth);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                               cropRect.origin.x/size.width,
                                               cropRect.size.height/fixHeight,
                                               cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                               (cropRect.origin.x + fixPadding)/fixWidth,
                                               cropRect.size.height/size.height,
                                               cropRect.size.width/fixWidth);
        }
        
        AVCaptureVideoPreviewLayer* layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [layer setFrame:self.view.layer.bounds];
        [self.view.layer addSublayer:layer];
        
        self.imageCover.frame = cropRect;
        [self.view addSubview:self.imageCover];
        
        if ([NIMSysManager sharedInstance].GetNetStatus != LOGINED) {
            self.imageCover.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
            self.tipsL.text = @"连接失败，请检查你的网络设置";
            [self.view addSubview:self.tipsL];
        }

        if (_scan != SCAN_MODE_TAP_YES) {
            self.scanImageView.frame = CGRectMake((self.imageCover.frame.size.width-226)/2.0, 0, 226, 21);
        }
        [self.imageCover addSubview:self.scanImageView];
        if (_scan != SCAN_MODE_TAP_YES && [NIMSysManager sharedInstance].GetNetStatus == LOGINED) {
            [self scanImageViewAnimation];
        }else{
            [self.scanImageView removeFromSuperview];
        }

        CGFloat kWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
        CGFloat kHeight = [UIApplication sharedApplication].keyWindow.bounds.size.height;
        CALayer* leftLayer = [[CALayer alloc] init];
        leftLayer.backgroundColor = kCoverColor.CGColor;
        leftLayer.frame = CGRectMake(0, 0, cropRect.origin.x, kHeight);
        [self.view.layer addSublayer:leftLayer];
        
        CALayer* rightLayer = [[CALayer alloc] init];
        rightLayer.backgroundColor = kCoverColor.CGColor;
        rightLayer.frame = CGRectMake(cropRect.origin.x+cropRect.size.width, 0, kWidth-(cropRect.origin.x+cropRect.size.width), kHeight);
        [self.view.layer addSublayer:rightLayer];
        
        CALayer* topLayer = [[CALayer alloc] init];
        topLayer.backgroundColor = kCoverColor.CGColor;
        topLayer.frame = CGRectMake(cropRect.origin.x, 0, kWidth-cropRect.origin.x*2, cropRect.origin.y);
        [self.view.layer addSublayer:topLayer];
        
        CALayer* bottomLayer = [[CALayer alloc] init];
        bottomLayer.backgroundColor = kCoverColor.CGColor;
        bottomLayer.frame = CGRectMake(cropRect.origin.x, cropRect.origin.y+cropRect.size.height, kWidth-cropRect.origin.x*2, kHeight-(cropRect.origin.y+cropRect.size.height));
        [self.view.layer addSublayer:bottomLayer];
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, cropRect.origin.y+cropRect.size.height+20, [UIApplication sharedApplication].keyWindow.bounds.size.width, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"将二维码放入框内，即可自动扫描";
        [self.view addSubview:lab];
    }
    return _session;
}

- (void)scanImageViewAnimation{
    if(_session)
    {
        [UIView animateWithDuration:1.5
                         animations:^{
                             self.scanImageView.frame = CGRectMake((self.imageCover.frame.size.width-226)/2.0, self.imageCover.frame.size.height-21, 226, 21);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:1.5
                                              animations:^{
                                                  self.scanImageView.frame = CGRectMake((self.imageCover.frame.size.width-226)/2.0, 0, 226, 21);
                                              }
                                              completion:^(BOOL finished) {
                                                  [self scanImageViewAnimation];
                                              }];
                         }];
    }
}

#pragma mark getter
- (UIBarButtonItem*)rightItem{
    if(!_rightItem){
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(chooseImage:)];
        _rightItem.tintColor = [SSIMSpUtil getColor:@"66666e"];
    }
    return _rightItem;
}

- (UIImageView*)scanImageView{
    if(!_scanImageView){
        _scanImageView = [[UIImageView alloc] init];
        _scanImageView.image = IMGGET(@"qbm_scanQR_saomiao_line");
    }
    return _scanImageView;
}

- (UIImageView*)imageCover{
    if(!_imageCover){
        _imageCover = [[UIImageView alloc] init];
        _imageCover.image = [IMGGET(@"qbm_scanQR_saomiao_bg") stretchableImageWithLeftCapWidth:110 topCapHeight:110];
    }
    return _imageCover;
}

-(UILabel *)tipsL
{
    if (!_tipsL) {
        _tipsL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.imageCover.frame), 60)];
        _tipsL.center = self.imageCover.center;
        _tipsL.textColor = [UIColor whiteColor];
        _tipsL.lineBreakMode = NSLineBreakByCharWrapping;
        _tipsL.font = [UIFont systemFontOfSize:15];
        _tipsL.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsL;
}
@end
