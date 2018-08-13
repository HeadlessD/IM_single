//
//  QBHtmlWebViewController.h
//  QianbaoIM
//
//  Created by liunian on 14/9/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"
static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};


@interface NIMHtmlWebViewController : NIMViewController
@property (nonatomic, strong) NSMutableDictionary *linkDict;
@property (nonatomic, assign) BOOL isNotReport;
@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,strong) NSString *senderId;
@property (nonatomic ,strong)NSString  *actualTitle;
@property (nonatomic,strong) NSString * uuid;
@property (nonatomic,strong) NSString *sourceChannel;
@property (nonatomic, assign) CGPoint remindPoint;
@property (nonatomic, assign) BOOL    loadDetail;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic,strong)NSTimer *_timer;    // 用于UIWebView保存图片
@property (nonatomic)int _gesState;      // 用于UIWebView保存图片
@property (nonatomic,strong)NSString *_imgURL;  // 用于UIWebView保存图片
@property (nonatomic, assign) BOOL   canFav;

- (void)ajaxCallBack:(NSString *)jsString;
-(void)subCribeCallBack:(NSString*)domainString jsString:(NSString*)jsString;
@end
