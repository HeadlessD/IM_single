//
//  NIMPrivacyViewController.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/26.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMPrivacyViewController.h"
#import "NIMSelectBlackListVC.h"
#import "NIMMomentBlackListVC.h"
#import "GKCover.h"

@interface NIMPrivacyViewController ()
@property(nonatomic,strong)DFSettingItem *item;
@property(nonatomic,assign)BOOL picFree;
@property(nonatomic,assign)BOOL notice;
@property(nonatomic,assign)Moments_Scope scope;
@property(nonatomic,strong)UIView *bgView;

@end

@implementation NIMPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _item = [NIMMomentsManager sharedInstance].setItem;
    
    if (!_item || _item.userId == 0) {
        _item = [[DFSettingItem alloc] init];
        _item.userId = OWNERID;
        _item.momentsEnable = YES;
        _item.listPicFree = NO;
        _item.momentsNotice = YES;
        _item.momentsScope = Moments_Scope_All;
        [NIMMomentsManager sharedInstance].setItem = _item;
    }
    _picFree = _item.listPicFree;
    _notice = _item.momentsNotice;
    _scope = _item.momentsScope;
    _listPicSwitch.on = _item.listPicFree;
    _tipSwitch.on = _item.momentsNotice;
    [self setModel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_picFree != _item.listPicFree ||
        _notice != _item.momentsNotice ||
        _scope != _item.momentsScope) {
        if (self.settingBlock) {
            self.settingBlock(_item);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setListPic:(id)sender {
    UISwitch *picSwitch = sender;
    _item.listPicFree = picSwitch.on;
}

- (IBAction)setTip:(id)sender {
    UISwitch *tipSwitch = sender;
    _item.momentsNotice = tipSwitch.on;
}


-(void)setModel
{
    switch (_item.momentsScope) {
        case Moments_Scope_All:
            _modelLabel.text = @"全部";
            break;
        case Moments_Scope_Day:
            _modelLabel.text = @"最近三天";
            break;
        case Moments_Scope_Year:
            _modelLabel.text = @"最近半年";
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NIMMomentBlackListVC *blackList = [[NIMMomentBlackListVC alloc] init];
        blackList.title = @"朋友圈黑名单";
        blackList.listType = List_Type_Black;
        [self.navigationController pushViewController:blackList animated:YES];
    }else if (indexPath.row == 1){
        NIMMomentBlackListVC *blackList = [[NIMMomentBlackListVC alloc] init];
        blackList.title = @"朋友圈不关注名单";
        blackList.listType = List_Type_NotCare;
        [self.navigationController pushViewController:blackList animated:YES];
    }else if (indexPath.row == 3) {
        [self selectModelView];
    }
}

-(void)selectModelView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, SCREEN_WIDTH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(_bgView.frame)-40, 40)];
    tipL.numberOfLines = 0;
    tipL.textColor = [UIColor blackColor];
    tipL.font = [UIFont systemFontOfSize:20];
    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.text = @"允许朋友查看朋友圈的范围";
    [_bgView addSubview:tipL];
    
    NSArray *titles = @[@"最近半年",@"最近三天",@"全部"];
    
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tipL.frame)+20+i*50, CGRectGetWidth(_bgView.frame)-20, 30)];
        if (_item.momentsScope == 3-i-1) {
            [btn setImage:[UIImage imageNamed:@"mart_favorites_cancel_select_on"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"mart_favorites_cancel_select"] forState:UIControlStateNormal];
        }
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20, 0.0, 0.0)];
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        [_bgView addSubview:btn];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_bgView.frame)-80, CGRectGetMaxY(_bgView.frame)-40, 50, 20)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 4;
    [_bgView addSubview:btn];
    [GKCover translucentWindowCenterCoverContent:_bgView animated:NO notClick:NO];
}

-(void)clickBtn:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            _item.momentsScope = Moments_Scope_Year;
            break;
        case 2:
            _item.momentsScope = Moments_Scope_Day;
            break;
        case 3:
            _item.momentsScope = Moments_Scope_All;
            break;
        case 4:
            break;
        default:
            break;
    }
    [self setSelect:button.tag];
    [GKCover hide];
    [self setModel];
}

-(void)setSelect:(NSInteger)tag
{
    for (int i=0; i<3; i++) {
        UIButton *btn = [_bgView viewWithTag:i+1];
        if (i==tag) {
            [btn setImage:[UIImage imageNamed:@"mart_favorites_cancel_select_on"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"mart_favorites_cancel_select"] forState:UIControlStateNormal];
        }
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/



@end
