//
//  DFModifyViewController.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/2.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "DFModifyViewController.h"
#import "NIMSelectBlackListVC.h"


@interface DFModifyViewController ()<NIMSelectBlackListVCDelegate>

@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *subTitles;
@property(nonatomic,strong)NSString *white;
@property(nonatomic,strong)NSString *black;
@property(nonatomic,strong)NSArray *users;

@end

@implementation DFModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self qb_setTitleText:@"谁可以看"];
    [self qb_showRightButton:@"确定"];
    _titles = @[@"公开",@"私密",@"部分可见",@"不给谁看"];
    _subTitles = @[@"所有朋友可见",@"仅自己可见",@"选中的朋友可见",@"选中的朋友不可见"];
    
    NSString *key = _IM_FormatStr(@"%ld",_index);
    switch (_index) {
        case 2:
            _white = getObjectFromUserDefault(key);
            break;
        case 3:
            _black = getObjectFromUserDefault(key);
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)qb_rightButtonAction
{
    if ([_delegate respondsToSelector:@selector(modifyViewController:didSelectPriType:users:)]) {
        Moments_Priv_Type type = _index+1;
        [_delegate modifyViewController:self didSelectPriType:type users:self.users];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_index == section) {
        if (_index == 2 || _index == 3) {
            return 1;
        }
    }
    return 0;
}


//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.tag = 1000 + section;
    view.backgroundColor = [UIColor whiteColor];
    [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = _titles[section];
    [view addSubview:label];
    
    UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH*0.5, 20)];
    sublabel.textColor = [UIColor blackColor];
    sublabel.font = [UIFont systemFontOfSize:11];
    sublabel.text = _subTitles[section];
    [view addSubview:sublabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    [view addSubview:line];

    //icon_signup_select
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 20, 20)];
    imgView.image = [UIImage imageNamed:@"icon_signup_select"];
    if (section == _index) {
        imgView.hidden = NO;
    }else{
        imgView.hidden = YES;
    }
    [view addSubview:imgView];
    
    return view;
    
}



 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
     if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
     }
     NSString *title = @"";
     if (_index == indexPath.section) {
         switch (_index) {
             case 2:
                 title = _white;
                 break;
             case 3:
                 title = _black;
                 break;
                 
             default:
                 break;
         }
     }
     cell.textLabel.text = title;
     return cell;
 }


#pragma mark - NIMSelectBlackListVCDelegate

-(void)selectListViewController:(NIMSelectBlackListVC *)viewController didSelectUsers:(NSArray *)users userNames:(NSArray *)userNames
{
    NSString *name = [userNames componentsJoinedByString:@","];
    if (viewController.isBlack) {
        _index = 3;
        _black = name;
    }else{
        _index = 2;
        _white = name;
    }
    setObjectToUserDefault(_IM_FormatStr(@"%ld",(long)_index), name);
    self.users = users;
    [self.tableView reloadData];
}

/**
 *  cell收缩/展开 刷新
 *
 *  @param view <#view description#>
 */
-(void)sectionClick:(UIControl *)view{
    
    //获取点击的组
    NSInteger i = view.tag - 1000;
    if (i==0||i == 1) {
        _index = i;
        //刷新列表
        [self.tableView reloadData];
    }else if (i == 2) {
        NIMSelectBlackListVC *blackList = [[NIMSelectBlackListVC alloc] init];
        blackList.delegate = self;
        blackList.showSelected = NO;
        blackList.isBlack = NO;
        [self.navigationController pushViewController:blackList animated:YES];
    }else{
        NIMSelectBlackListVC *blackList = [[NIMSelectBlackListVC alloc] init];
        blackList.delegate = self;
        blackList.showSelected = NO;
        blackList.isBlack = YES;
        [self.navigationController pushViewController:blackList animated:YES];
    }
    
    
}

-(NSArray *)users
{
    if (!_users) {
        _users = [[NSArray alloc] init];
    }
    return _users;
}




@end
