//
//  NIMReportDetailViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/10/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMReportDetailViewController.h"
//#import "NIMFeedOperationBox.h"
//#import "NIMGoodsOperationBox.h"
#import "NIMUserOperationBox.h"

@interface NIMReportDetailViewController ()<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel* labPloceHold;
@property (nonatomic, weak) IBOutlet UILabel* labCount;
@property (nonatomic, weak) IBOutlet UITextView* textView;
@end

@implementation NIMReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"举报"];
    [self qb_showRightButton:@"发送"];
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reportGoods{
    NSString* text = [NSString nim_trim:_textView.text];
    if(text.length == 0){
//        [MBProgressHUD showError:@"请输入举报原因" toView:self.view];
        return;
    }
    [self qb_showLoading];
//    [[NIMOperationBox sharedInstance]reportProductWithProductId:_uuid remark:_textView.text completeBlock:^(id object, QBResultMeta *result) {
//        [self qb_hideLoadingWithCompleteBlock:^{
//            
//        }];
//        if(result){
//            [MBProgressHUD showError:result.message toView:self.view];
//        }
//        else{
//            [MBProgressHUD showSuccess:@"举报成功" toView:[UIApplication sharedApplication].keyWindow];
//            [self qb_back];
//        }
//    }];
}

- (void)reportIMuser{
    NSString* text = [NSString nim_trim:self.textView.text];
    if(text.length == 0){
//        [MBProgressHUD showError:@"请输入举报原因" toView:self.view];
        return;
    }
    [self qb_showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:self.userId forKey:@"reportUserId"];
    [params setObject:self.userName forKey:@"reportUserName"];
//    NSString  *reason_content = [Util trimString:self.textView.text];
//    if (reason_content && reason_content.length > 0) {
//        [params setObject:reason_content forKey:@"content"];
//    }

    
//    [[NIMManager sharedImManager]qb_httpRequestMethod:HttpMethodPost url:SERVERURL_IMreport parameters:params successBlock:^(id object, QBResultMeta *result) {
//        [self qb_hideLoadingWithCompleteBlock:^{
//            
//        }];
//        [MBProgressHUD showSuccess:@"举报成功" toView:[UIApplication sharedApplication].keyWindow];
//        [self qb_back];
//    } failedBlock:^(id object, QBResultMeta *result) {
//        [self qb_hideLoadingWithCompleteBlock:^{
//            
//        }];
//        [MBProgressHUD showError:result.message toView:self.view];
//    }];
    
}

- (void)qb_rightButtonAction{
    if(_textView.text.length==0){
//        [MBProgressHUD showSuccess:@"请输入举报原因" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if(_isGoods){
        [self reportGoods];
    }
    else if (_isIMChat)
    {
        [self reportIMuser];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//        [[FeedOperationBox sharedInstance] reportFeedWithUuid:self.uuid
//                                                   reportType:IMReportTypeFeed
//                                                  reason_type:IMReportReasonTypeLaw
//                                               reason_content:[self.textView text]
//                                                completeBlock:^(id object, QBResultMeta *result) {
//                                                    
//                                                    void (^nOperateFeedCallBackBlock)(id object, QBResultMeta *result);
//                                                    nOperateFeedCallBackBlock = ^(id object, QBResultMeta *result)
//                                                    {
//                                                        [MBProgressHUD hideHUDForView:self.view animated:NO];
//                                                        if(object)
//                                                        {
//                                                            [MBProgressHUD showError:@"举报成功" toView:[UIApplication sharedApplication].keyWindow];
//                                                            [self qb_back];
//                                                        }
//                                                        else
//                                                        {
//                                                            [MBProgressHUD showError:result.message toView:self.view];
//                                                        }
//                                                        
//                                                    };
//                                                    
//                                                    if ([NSThread isMainThread])
//                                                    {
//                                                        nOperateFeedCallBackBlock(object, result);
//                                                    }
//                                                    else
//                                                    {
//                                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                            nOperateFeedCallBackBlock(object, result);
//                                                        });
//                                                    }
//                                                    
//                                                    
//                                                }];
    }
}

- (void)qb_back{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length!=0)
    {
        _labPloceHold.hidden = YES;
    }
    else{
        _labPloceHold.hidden = NO;
    }
    if(textView.text.length>200 && textView.markedTextRange == nil){
        _textView.text = [textView.text substringToIndex:200];
    }
    _labCount.text = [NSString stringWithFormat:@"%d/200",_textView.text.length];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

@end
