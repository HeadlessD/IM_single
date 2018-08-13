//
//  AppDelegate.m
//  IM_single
//
//  Created by 豆凯强 on 2018/1/9.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "AppDelegate.h"

#import "SSIMThreadViewController.h"
#import "SSIMBusinessManager.h"
#import <Bugly/Bugly.h>
#import "sys/utsname.h"
#import "NIMAuthorManager.h"
#import "NIMLoginViewController.h"

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SSIMThreadViewController alloc] init]];
    // Init the Bugly sdk
    [Bugly startWithAppId:BUGLY_APP_ID];
    
    //上传crash日志到服务器
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
//    [self updateErrorToServer];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSDictionary *dic = getObjectFromUserDefault(@"imuserInfo");
    if (dic) {
        [[SSIMBusinessManager sharedInstance] loginAction];
        UITabBarController * newTabbar = [[SSIMBusinessManager sharedInstance] loadTabbar];
        self.window.rootViewController = newTabbar;
    } else {
        NIMLoginViewController *logvc = [[NIMLoginViewController alloc] init];
        self.window.rootViewController = logvc;
        logvc.loginOk = ^{
            UITabBarController * newTabbar = [[SSIMBusinessManager sharedInstance] loadTabbar];
            self.window.rootViewController = newTabbar;
        };
    }
    
//    [[UINavigationController alloc]initWithRootViewController:[[NIMLoginViewController alloc]init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    [Bugly reportException:exception];

//    NSArray *errorArr = [exception callStackSymbols];//得到当前调用栈信息
//    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
//    NSString *name = [exception name];//异常类型
//    NSString *errorStr = [NSString stringWithFormat:@"%@\n%@\n%@",name,reason,errorArr];
//    [[NSUserDefaults standardUserDefaults] setObject:errorStr forKey:@"errorStr"];
}

- (void)updateErrorToServer {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * phoneModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];//手机型号
    NSString *strSysName = [[UIDevice currentDevice] systemVersion];//版本号
    NSString *errorStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"errorStr"];
    if (errorStr == nil || errorStr.length == 0) {
        return;
    }
    
}
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    //#if DEBUG
    config.debugMode = YES;
    //#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NIMAuthorManager sharedInstance] getNetworkAuthorReturnResultWithBlock:^(NSString *resultStr) {
        
    }];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
