//
//  NIMAuthorManager.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/9.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMAuthorManager.h"
#import <CoreTelephony/CTCellularData.h>
@implementation NIMAuthorManager
SingletonImplementation(NIMAuthorManager)


/**
 * 调取联网权限
 */
- (void)getNetworkAuthorReturnResultWithBlock:(void(^)(NSString *resultStr))resultBlock {
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    /*
     此函数会在网络权限改变时再次调用
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAppInfo];
                });
            }
                break;
            case kCTCellularDataNotRestricted:
                
                break;
            case kCTCellularDataRestrictedStateUnknown:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAppInfo];
                });
            }
                break;
                
            default:
                break;
        }
    };
    
}

-(void)getAppInfo
{
    
    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus toStatus = [internetReachability currentReachabilityStatus];

    if (_isShow || toStatus != NotReachable) {
        return;
    }
    UIViewController *topmostVC = [SSIMSpUtil topViewController];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 凤雏 - 无线数据] 打开联网开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _isShow = NO;
    }];
    [alertC addAction:alertA];
    [topmostVC presentViewController:alertC animated:YES completion:^{
    }];
    _isShow = YES;
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self reachability:curReach];
}

- (void)reachability:(Reachability *)reachability
{
    NetworkStatus toStatus = [reachability currentReachabilityStatus];

    NSLog(@"---------网络发生变化%ld--------- ",(long)toStatus);
}

@end
