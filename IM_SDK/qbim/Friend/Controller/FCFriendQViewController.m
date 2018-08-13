//
//  FCFriendQViewController.m
//  qbnimclient
//
//  Created by shiyunjie on 2018/1/4.
//  Copyright © 2018年 秦雨. All rights reserved.
//

#import "FCFriendQViewController.h"

@interface FCFriendQViewController ()

@end

@implementation FCFriendQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    UIImage *bgImage = [SSIMSpUtil scaleFromImage:IMGGET(@"bg_rich_topbar") toSize:_CGS(GetWidth([UIApplication sharedApplication].keyWindow), 64)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
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
