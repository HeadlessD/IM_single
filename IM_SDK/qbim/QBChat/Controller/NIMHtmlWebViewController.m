//
//  QBHtmlWebViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/9/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMHtmlWebViewController.h"
#import "NIMLatestVcardViewController.h"
//#import "QBCreatFeedViewController.h"
#import "NIMPopView.h"
#import "NIMHttpRequestHeader.h"
#import "NIMReportViewController.h"
//#import "PublicOperationBox.h"
//#import "ZXingObjC.h"
#import "GTMBase64.h"
#import "NIMLoginOperationBox.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "UIWebView+TS_JavaScriptContext.h"
@interface NIMHtmlWebViewController ()<VcardForwardDelegate,NIMPopViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) NIMPopView *popView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIBarButtonItem *qb_closeBarButton;
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, strong) NSString *lastLink;
@property (nonatomic, strong) NSString *m_userId;
@property (nonatomic, strong) NSString *sendImage;
@property (nonatomic, strong) NSString *baogouMask;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL isSendImage;
@property (nonatomic, assign) BOOL isSelectImage;

@end

@implementation NIMHtmlWebViewController

- (void)dealloc
{
    [_popView qb_hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.linkDict objectForKey:@"url"]) {
        self.link = [self.linkDict objectForKey:@"url"];
        //        [self.link com]
        if([self.link rangeOfString:@"://"].length >0){
            
        }else{
            self.link = [NSString stringWithFormat:@"http://%@",self.link];
        }
        NSString *schma=[[self.link componentsSeparatedByString:@"://"] firstObject];
        NSString *lowsc=[schma lowercaseString];
        NSString *path=[self.link substringFromIndex:schma.length];
        NSString *dst=[NSString stringWithFormat:@"%@%@",lowsc,path];
        if(![SSIMSpUtil stringA:dst containString:@"?"]){
            dst = [dst stringByAppendingString:@"?devType=iphone"];
        }else{
            dst = [dst stringByAppendingString:@"&devType=iphone"];
        }
        self.link = dst;
    }
    NSString *str = [[self.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if([SSIMSpUtil stringA:str containString:SERVER_BAOYUE_SCAN]){//如果是宝约核销-加参数
//        NSString *st = [[NIMLoginOperationBox sharedInstance] pqb_baoyuest];
//          str = [NSString stringWithFormat:@"%@&st=%@",str,st];
//    }
    
    self.webUrl= [NSURL URLWithString:str];
    self.webView.allowsInlineMediaPlayback = YES;
    self.closeButton.hidden = YES;
    self.rightButton.enabled=YES;
    if (self.userId.length == 0) {
        self.userId = [NSString stringWithFormat:@"%ld",(long)OWNERID];
    }
    if (IsStrEmpty(self.senderId)) {
        self.m_userId = self.userId;
    }
    else
    {
        self.m_userId =self.senderId;
    }
}

- (void)qb_rightButtonAction{
   
    UIAlertAction *shareBtn =nil;
    UIAlertAction *reportBtn =nil;
    UIAlertAction *collectBtn =nil;
    
    shareBtn = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionForward:nil];
    }];
    if(self.isNotReport==NO)
    {
        
        reportBtn = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NIMReportViewController* reportVC  =[[NIMReportViewController alloc] initWithNibName:@"NIMReportViewController" bundle:nil];
            reportVC.reportType = @"5";
            reportVC.isTweet =YES;
            reportVC.tweeturl =self.lastLink;
            reportVC.linkurl =self.lastLink;
            reportVC.pushType =@"push";
            [self nim_pushToVC:reportVC animal:YES];
        }];
    }
    if (IsStrEmpty(self.uuid)) {
        collectBtn = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            

        }];
        
    }
    else
    {
        if (self.canFav) {
            collectBtn =[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
        }
        else{
            collectBtn =[UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];

        }
    }
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                    DLog(@"No");
                                                }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:cancel];
    [alertController addAction:reportBtn];
    [alertController addAction:shareBtn];
    [alertController addAction:collectBtn];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)getBindGoodsDetail
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.link) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.webUrl];
        
        [self.webView loadRequest:request];
    }
    
    
    [self qb_showRightButton:nil andBtnImg:IMGGET(@"icon_public_more")];
    
     [self qb_setRightButtonHidden:YES];
    
//    if ([self.actualTitle isEqualToString:@"历史消息"])
//    {
//        [self qb_setRightButtonHidden:YES];
//    }
//    else
//    {
//        [self qb_setRightButtonHidden:NO];
//    }
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showLatestVcardViewController:(BOOL)animated{
    
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"FriendShip" bundle:nil] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.delegate = self;
    }
    
    [self.navigationController presentViewController:latestVcardNavigation animated:YES completion:^{
        
    }];
}
#pragma mark
- (void)qb_setNavLeftButtonSpace
{
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:self.qb_leftBarButton];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, self.qb_leftBarButton,self.qb_closeBarButton,nil]];
}
#pragma mark
- (void)shareLinkToFeed{
}

#pragma mark actions
- (IBAction)actionForward:(id)sender{

  
}



#pragma mark -- QBPopBaseContextViewDelegate
- (void)didSelectUpdateModel:(NSNumber*)shareType
{
}


- (void)qb_back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)qb_close{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark VcardForwardDelegate
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    if (self.isSendImage==NO) {
        if(thread.length==0)return;
        if (self.linkDict) {
//            NSString *title = self.linkDict[@"title"];
//            NSString *img_url = self.linkDict[@"img_url"];
//            NSString *url = self.linkDict[@"url"];
//            NSString *desc = self.linkDict[@"description"];
//            if (desc == nil) {
//                desc = url;
//            }
//            if (title && img_url && url && desc && source) {
//                [[MessageOperationBox sharedInstance] shareLinkTitle:title image:img_url url:url source:source description:desc toThread:thread completeBlock:^(id object, QBResultMeta *result) {
//                    [QBClick event:kUMEventId_3057];
//                    completeBlock(VcardSelectedActionTypeForward, object, result);
//                }];
//            }else{
//                completeBlock(VcardSelectedActionTypeForward,nil,[QBResultMeta resultWithCode:QBIMErrorParameter error:@"" message:@"分享内容不完整"]);
//            }
        }
    }
    else
    {
        if(thread.length == 0){
            [UIView animateWithDuration:0.3
                             animations:^{
                                 viewController.navigationController.view.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 [viewController.navigationController.view removeFromSuperview];
                                 [viewController.navigationController removeFromParentViewController];
                             }];
            return;
        }
        //NSString *imageString = viewController.objectForward;
//        [[MessageOperationBox sharedInstance] sendMessage:imageString thread:thread packetContentType:PacketContentTypeImage packetSubtypeType:PacketSubtypeTypeChat cardType:CardTypeNone completeBlock:^(id object, QBResultMeta *result) {
//            void(^callBack)();
//            callBack = ^(){
//                [MBProgressHUD hideAllHUDsForView:nil animated:NO];
//                [UIView animateWithDuration:0.3
//                                 animations:^{
//                                     viewController.navigationController.view.alpha = 0.0;
//                                 }
//                                 completion:^(BOOL finished) {
//                                     [viewController dismissViewControllerAnimated:YES completion:nil];
//                                 }];
//                [MBProgressHUD showSuccess:@"已分享" toView:[UIApplication sharedApplication].keyWindow];
//                
//            };
//            if([NSThread isMainThread]){
//                callBack();
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    callBack();
//                });
//            }
//        }];
//        
    }
}

- (void)shareLinkToFeedWithTask:(NSDictionary *)task_dic{
    
    
}
-(void)qb_pushToAppdetailView:(NSString*)url
{

    
}

/*
 
 */
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* rurl                  = [[request URL] absoluteString];
    DBLog(@"QBHtmlWebViewController url = %@",rurl);
//    NSString *info                  = nil;

    NSArray *components = [rurl componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //DBLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                self._gesState = GESTURE_STATE_START;
                DBLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                DBLog(@"touch point (%f, %f)", ptX, ptY);
                
                
                CGPoint point = CGPointMake(ptX, ptY);
                self.remindPoint = point;
                self.loadDetail = YES;
                self.beginDate = [NSDate date];
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];

                if ([tagName isEqualToString:@"IMG"]) {
                    self.isSelectImage=YES;
                    self._imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                else{
                    self.isSelectImage=NO;
                }
                if (self._imgURL) {
                    self._timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }

            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                self._gesState = GESTURE_STATE_MOVE;
                self.loadDetail = NO;
                DBLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                [self._timer invalidate];
                self._timer = nil;
                self._gesState = GESTURE_STATE_END;
                DBLog(@"touch end");
            
            }
        }
        
        return NO;
    }
    
    
//    WEBFILTER_RESULT t_filterResult = [[NIMWebViewFilter shareFilter] filterForUrl:rurl info:&info];

    NSString     *url   = [rurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL        *_url  = [NSURL URLWithString:url];
    NSDictionary *prams = [self dictionaryFromQuery:[_url query] usingEncoding:NSUTF8StringEncoding];
    NSString     *userId  =  PUGetObjFromDict(@"userId", prams, [NSString class]);
//    NSString     *authenticationFlag  =  PUGetObjFromDict(@"authenticationFlag", prams, [NSString class]);
//    NSString     *mainImg  =  PUGetObjFromDict(@"mainImg", prams, [NSString class]);
//    NSString     *productPriceFen  =  PUGetObjFromDict(@"productPriceFen", prams, [NSString class]);
//    NSString     *title  =  PUGetObjFromDict(@"title", prams, [NSString class]);
//    NSString     *desc  =  PUGetObjFromDict(@"desc", prams, [NSString class]);
//    NSString     *newurl  =  PUGetObjFromDict(@"url", prams, [NSString class]);
//    double userid = [userId doubleValue];
    
    return YES;
}


/**
 *  跳转到频道详情页面
 */
- (void)qb_pushToChannelWebView:(QBFoundCellModel *)model showToolBar:(BOOL)showToolBar
{

}


- (void)push:(BOOL)isPush s_dic:(NSDictionary *)s_dic thread:(NSString *)thread
{
    if (isPush) {
//        [[MessageOperationBox sharedInstance] forgeProductInfo:s_dic subType:PacketSubtypeTypeBGProduct thread:thread completeBlock:^(id object, QBResultMeta *result) {
//            
//            if ([NSThread isMainThread]) {
//                [self showChatControllerWithThread:thread];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self showChatControllerWithThread:thread];
//                });
//            }
//            
//        }];
    }
}

- (void)shareBtnAction
{
    
}

- (void)showChatControllerWithThread:(NSString *)thread{
    
}
//发布商品
- (void)showPublicGoods{
    
}
//显示公众号
- (void)showPublicInfo:(NSString*)publicId{

}

//到群组界面
- (void)showGroup:(double)groupId{
    
}

//TODO:从相册读取图片
- (NSString*)ScanInfoFromImage:(UIImage*)image{
    
//    UIImage *loadImage= image;
//    CGImageRef imageToDecode = loadImage.CGImage;
//    
//    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
//    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
//    
//    NSError *error = nil;
//    
//    ZXDecodeHints *hints = [ZXDecodeHints hints];
//    
//    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
//    ZXResult *result = [reader decode:bitmap
//                                hints:hints
//                                error:&error];
//    
//    NSString* codeString = @"";
//    if (result) {
//        
//        codeString = result.text;
//        
//        DBLog(@"相册图片contents == %@",codeString);
//        
//    } else {
//        
//        
//        
//    }
    
    return nil;
}

// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    DBLog(@"%@", self._imgURL);
    if (self._imgURL && self._gesState == GESTURE_STATE_START) {
        if (self._imgURL) {
            DBLog(@"imgurl = %@", self._imgURL);
        }
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:self._imgURL];
        if([SSIMSpUtil isEmptyOrNull:urlToSave])
        {
            return;
        }
        else
        {
            DBLog(@"image url = %@", urlToSave);
            self.sendImage = urlToSave;
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
            UIImage* image = [UIImage imageWithData:data];
            
            UIAlertAction * saveBtn = [UIAlertAction actionWithTitle:@"保存到手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
                DBLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                
            }];
            UIAlertAction * sendBtn = [UIAlertAction actionWithTitle:@"发送给好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"FriendShip" bundle:nil] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
                if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
                    NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
                    latestVVC.delegate = self;
                    latestVVC.objectForward = urlToSave;
                }
                
                [self.navigationController presentViewController:latestVcardNavigation animated:YES completion:^{
                    
                }];
                
                self.isSendImage =YES;
            }];
//            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.isSendImage =NO;
//            }];
            
            UIAlertAction * scanBtn = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *codeStr = [self ScanInfoFromImage:image];
                [self parseString:codeStr];
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            if([self readInfoFromImage:image ]==YES)
            {
                [alertController addAction:saveBtn];
                [alertController addAction:sendBtn];
                [alertController addAction:scanBtn];
            }
            else
            {
                [alertController addAction:saveBtn];
                [alertController addAction:sendBtn];
            }
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
}



// 功能：显示对话框
-(void)showAlert:(NSString *)msg {    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];


}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        DBLog(@"Error");
        [self showAlert:@"保存失败..."];
    }else {
        DBLog(@"OK");
        [self showAlert:@"保存成功！"];
    }
}

- (BOOL)isQBHtml:(NSString*)str{
    str = [str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    if([str hasPrefix:@"user.qbao.com/usercenter/promote.html"])return YES;
    if([str hasPrefix:@"a.qbao.com"])return YES;
    if([str hasPrefix:@"qianb.cn"])return YES;
    if([str hasPrefix:@"qba.la"])return YES;
    if([str hasPrefix:@"im.qbao.com"])return YES;
    if([str hasPrefix:@"im.qianbao666.com"])return YES;
    if ([str hasPrefix:@"im.qbao.com"]) return YES;
    if([str hasPrefix:[NSString stringWithFormat:@"%@/usercenter/promote.html",SERVER_USER_QB]])return YES;
    return NO;
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

//TODO:解析获取到的字符串
- (void)parseString:(NSString*)str{
    
    /*
    BOOL isQBHeml = [self isQBHtml:str];
    if(!isQBHeml)
    {
        NSString* baseUrl = str;
        NSURL* url = [self smartURLForString:baseUrl];
        
        
        [[UIApplication sharedApplication] openURL:url];
        
        return;
        
    }
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
    if(tmp.count>=2)//从网页扫描的4种情况
    {
        NSString* baseCode = [tmp lastObject];
        NSData *data = [GTMBase64 decodeString:baseCode];
        NSString * url = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray* urlArray = [url componentsSeparatedByString:@"/"];
        NSString* key = urlArray[0];
        NSString* value = urlArray[1];
        if([key isEqualToString:@"user"])//用户，打开对方聊天界面
        {
            [self showChatView:value.doubleValue];
        }
        else if([key isEqualToString:@"ware"])//商品发布界面
        {
            if([value isEqualToString:@"add"]){
                [self showPublicGoods];
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
                
                NSString *url = [NSString stringWithFormat:@"%@spuId=%@&sourceType=%@&promoter=%@", GOODS_URL, [dic objectForKey:@"ware"], [dic objectForKey:@"sourceType"], [dic objectForKey:@"promoter"]];
                
                QBFoundCellControlModel *modle = [QBFoundCellControlModel new];
                modle.qb_url = url;
                
                modle.qb_title = @"商品详情";
                [self qb_pushToFoundControlWebViewController:url model:modle];
                
//                DBLog(@"商品链接为： %@", url);
//                
//                QBWebViewController *webView = [[QBWebViewController alloc] initWithNibName:@"QBWebViewController" bundle:nil];
//                [webView setWebTitle:@"商品详情" url:[NSURL URLWithString:url]];
//                webView.showToolBar = NO;
//                [self nim_pushToVC:webView animal:YES];
                
//                //  ware/715/sourceType/4/promoter/3898027
//                CommodityDetailViewController* detail = [[CommodityDetailViewController alloc] initWithNibName:@"CommodityDetailViewController" bundle:nil];
//                detail.productId = [dic objectForKey:@"ware"];
//                detail.promoter = [dic objectForKey:@"promoter"];
//                detail.sourceType = [dic objectForKey:@"sourceType"];
//                [self.navigationController pushViewController:detail animated:YES];
                
            }
        }
        else if([key isEqualToString:@"seller"])//商家界面
        {
            [self showChatView:value.doubleValue];
        }
        else if([key isEqualToString:@"pub"])//公众号详情
        {
            [self showPublicInfo:value];
        }
        
    }
    else{
        
        
        if(isUser.count>=2){
            NSString* suid = isUser.lastObject;
            [self showChatView:suid.doubleValue];
        }
        if(isGroup.count>=2){
            NSString* gid = isGroup.lastObject;
            [self showGroup:gid.doubleValue];
        }
        
    }
     */
}

//图片是否是二维码图片
- (BOOL)readInfoFromImage:(UIImage*)image{
//    CGImageRef imageToDecode = image.CGImage;
//    ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode] ;
//    ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
//    NSError* error = nil;
//    ZXDecodeHints* hints = [ZXDecodeHints hints];
//    hints.encoding = NSUTF8StringEncoding;// StringEncoding;
//    ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
//    ZXResult* result = [reader decode:bitmap
//                                hints:nil
//                                error:&error];
//    if (result) {
//        return YES;
//    }
    return NO;
}

- (void)subcribePublic:(NSString*)publicid{
    
}

- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
        if ([pairString hasPrefix:@"url"]) {
            [pairs setObject:[pairString substringFromIndex:4] forKey:@"url"];
            
        }

    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.rightButton.hidden =YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.actualTitle isEqualToString:@"历史消息"])
    {
        if ([webView canGoBack])
        {
            [self qb_setRightButtonHidden:NO];
        }
        else
        {
            [self qb_setRightButtonHidden:YES];
        }
    }
    
    if ([webView canGoBack])
    {
        self.closeButton.hidden = NO;
    }
    else
    {
        self.closeButton.hidden = YES;
    }

    
    self.rightButton.hidden =YES;
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *link = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    //NSMutableArray *descdic=[self AnalyticalCont:link];
    //NSMutableArray *imagedic=[self Analyticalimag:link];
//    NSString *imageUrl=nil;
//    if (imagedic.count>0)
//    {
//        imageUrl =[imagedic objectAtIndex:0];
//        if([imageUrl hasSuffix:@"gif"] && imagedic.count>1)
//        {
//            imageUrl =[imagedic objectAtIndex:1];
//        }
//    }
    
//    NSString *desc= [descdic componentsJoinedByString:@","];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:[NSString nim_strToShowText:title] forKey:@"title"];
    //[dic setObject:[NSString strToShowText:imageUrl] forKey: @"img_url"];
    [dic setObject:[NSString nim_strToShowText:link] forKey:@"url"];
    //[dic setObject:[_linkDict objectForKey:@"digest"]? [_linkDict objectForKey:@"digest"]:[NSString strToShowText:desc] forKey:@"description"];
    [dic setObject:@"" forKey:@"source"];
    
    self.linkDict = dic.mutableCopy;
    self.lastLink =[self.linkDict objectForKey:@"url"];
    NSString *name = [NSString nim_strToShowText:title];
    if (name.length >6) {
        name = [name substringToIndex:6];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    if (IsStrEmpty(self.actualTitle)) {
        [self qb_setTitleText:name];
    }
    else
    {
        [self qb_setTitleText:self.actualTitle];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"isQianBaoiOSClient('%@');",@"1"]];
   [self.webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
//    NSString *string2 = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"isQianBaoiOSClient('%@');",@"1"]];
            // 禁用用户选择
    [self getBindGoodsDetail];
}

//到聊天界面
- (void)showChatView:(double)userid{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (NSString*)checkClassName:(NSString*)classUrl
{
    
    NSString *className = [self.webView stringByEvaluatingJavaScriptFromString:[classUrl stringByAppendingString:@".parentNode.className"]];
    if(className.length == 0)
    {
        return nil;
    }
    
    if ([className isEqualToString:@"history-details history-single"]) {
        return [classUrl stringByAppendingString:@".parentNode.getAttribute('url')"];
    }
    else
    {
        return [self checkClassName:[classUrl stringByAppendingString:@".parentNode"]];
        
    }
}
#pragma mark -- getter
_GETTER_BEGIN(UIBarButtonItem, qb_closeBarButton)
{
    _qb_closeBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.closeButton];
}
_GETTER_END(qb_closeBarButton)

_GETTER_BEGIN(UIButton, closeButton)
{
    _closeButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _CLEAR_BACKGROUND_COLOR_(_closeButton);
    _closeButton.exclusiveTouch  = YES;
    _closeButton.frame           = _CGR(0, 0, 40, 30);
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    
    [_closeButton.titleLabel setFont:FONT_TITLE(16)];
    [_closeButton addTarget:self action:@selector(qb_close) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(closeButton)

_GETTER_BEGIN(NIMPopView, popView)
{
    _popView = [NIMPopView popView];
    _popView.delegate = self;
}
_GETTER_END(popView)

@end
