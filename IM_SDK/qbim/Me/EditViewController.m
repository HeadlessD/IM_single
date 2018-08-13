//
//  EditViewController.m
//  qbnimclient
//
//  Created by shiyunjie on 2018/1/4.
//  Copyright © 2018年 秦雨. All rights reserved.
//

#import "EditViewController.h"
#import "EditTableViewCell.h"
#import "EditNickNameViewController.h"
#import "JFImagePickerController.h"
#import "UIActionSheet+nimphoto.h"
#import "NIMManager.h"
@interface EditViewController ()<JFImagePickerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * selfTableView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self qb_setTitleText:@"编辑个人资料"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selfTableView];
    self.selfTableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"%@",_vcardEntity.nickName);
    [_selfTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTableViewCell *cell = (EditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
    
    //取消点击背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置箭头
    if (indexPath.section == 0||indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (cell == nil) {
        cell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EditTableViewCell"];
    }
    [cell getViewModelWithIndex:indexPath withVcard:_vcardEntity];

    NSString * sexStr = @"";
    if ([_vcardEntity.sex isEqualToString:@"F"]) {
        sexStr = @"女";
    }else{
        sexStr = @"男";
    }
    NSString *nickName = @"暂无";
    NSString *mobile = @"暂无";
    NSString *mail = @"暂无";
    NSString *localtionCity = @"暂无";

    if (!IsStrEmpty(_vcardEntity.nickName)) {
        nickName = _vcardEntity.nickName;
    }
    if (!IsStrEmpty(_vcardEntity.mobile)) {
        mobile = _vcardEntity.mobile;
    }
    if (!IsStrEmpty(_vcardEntity.mail)) {
        mail = _vcardEntity.mail;
    }
    if (!IsStrEmpty(_vcardEntity.localtionCity)) {
        localtionCity = _vcardEntity.localtionCity;
    }
    NSArray * contArr = @[@"",nickName,mobile,sexStr,mail,localtionCity];

    cell.contentLabel.text = contArr[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        //TODO:相册
        [UIActionSheet nim_canPhotoLibraryWithYES:^{
            [JFImagePickerController setMaxCount:1];
            JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
            picker.pickerDelegate = self;
            [self.navigationController presentViewController:picker animated:YES completion:^{
            }];
        } withNO:^{
            
        }];
    } else if (indexPath.section == 1) {
        EditNickNameViewController * editNameView = [[EditNickNameViewController alloc]init];
        editNameView.vcardEntity = _vcardEntity;
        [self.navigationController pushViewController:editNameView animated:YES];
    }else{

    }
}


-(void)imagePickerDidFinished:(JFImagePickerController *)picker
{
    [picker hidden];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *oriImage = [UIImage imageWithCGImage:imageRef];
            [[NIMManager sharedImManager] uploadUserIcon:oriImage userid:OWNERID completeBlock:^(id object, NIMResultMeta *result) {
                [JFImagePickerController clear];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (result) {
                    [MBTip showTipsView:@"头像上传失败，请重新上传"];
                }else{
                    [[SDImageCache sharedImageCache] removeImageForKey:USER_ICON_URL(OWNERID)];
                    [self.selfTableView reloadData];
                }
            }];
        }];
        
    }
}

-(void)imagePickerDidCancel:(JFImagePickerController *)picker
{
    [picker hidden];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

-(UITableView *)selfTableView{
    if (!_selfTableView) {
        _selfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _selfTableView.delegate = self;
        _selfTableView.dataSource = self;
        _selfTableView.estimatedRowHeight = 0;
        _selfTableView.estimatedSectionHeaderHeight = 0;
        _selfTableView.estimatedSectionFooterHeight = 0;
        _selfTableView.showsVerticalScrollIndicator = NO;
        _selfTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //CELL边框边线
        _selfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selfTableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
        [_selfTableView registerClass:[EditTableViewCell class] forCellReuseIdentifier:@"EditTableViewCell"];
    }
//    [_selfTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.left.equalTo(@0);
//        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
//        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
//    }];
    return _selfTableView;
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
