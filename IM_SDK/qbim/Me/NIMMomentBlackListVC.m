//
//  NIMMomentBlackListVC.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/28.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMMomentBlackListVC.h"
#import "NIMSelectBlackListVC.h"

#import "NIMVcardCollectionViewCell.h"

#define itemCount 5

@interface NIMMomentBlackListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,VcardCollectionViewCellDelegate,NIMSelectBlackListVCDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray    *datasource;
@property(nonatomic,assign)BOOL isDel;

@end

@implementation NIMMomentBlackListVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_listType == List_Type_NotCare) {
        NSString *notCareList = [NIMMomentsManager sharedInstance].setItem.notCareList;
        if(!IsStrEmpty(notCareList)){
            self.datasource = [NSMutableArray arrayWithArray:[notCareList componentsSeparatedByString:@","]];
            [self.collectionView reloadData];
        }
    }else{
        NSString *blackList = [NIMMomentsManager sharedInstance].setItem.blackList;
        if(!IsStrEmpty(blackList)){
            self.datasource = [NSMutableArray arrayWithArray:[blackList componentsSeparatedByString:@","]];
            [self.collectionView reloadData];
        }
    }
    [self qb_setTitleText:self.title];
    [self qb_showRightButton:@"确定"];
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSetBlack:) name:NC_SET_BLACK_LIST object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows;
    if (self.datasource.count <=0) {
        rows = 1;
    }else{
        rows = _isDel?self.datasource.count:self.datasource.count+2;
    }
    return rows;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [self configCollectionViewCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(50,50);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
}



- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.datasource.count) {
        VcardEntity *contactEntity = nil;
        int64_t userid = [[self.datasource objectAtIndex:indexPath.row] longLongValue];
        contactEntity = [VcardEntity instancetypeFindUserid:userid];
        [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:USER_ICON_URL(contactEntity.userid)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
        if (_isDel) {
            cell.delImgView.hidden = NO;
        }
    }else if(indexPath.row == self.datasource.count){
        [cell.avatarBtn setBackgroundImage:[UIImage imageNamed:@"icon_group_add"] forState:UIControlStateNormal];
        cell.delImgView.hidden = YES;
    }else{
        [cell.avatarBtn setBackgroundImage:[UIImage imageNamed:@"icon_group_delete"] forState:UIControlStateNormal];
        cell.delImgView.hidden = YES;
    }
    [cell updateConstraints];
    cell.vcardDelegate = self;
}


-(void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIButton *)avatar
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    BOOL delHidden = cell.delImgView.hidden;
    if (delHidden) {
        if (indexPath.row < self.datasource.count) {
            
        }else if(indexPath.row == self.datasource.count){
            NIMSelectBlackListVC *blackList = [[NIMSelectBlackListVC alloc] init];
            blackList.delegate = self;
            blackList.showSelected = NO;
            blackList.selectedUsers = self.datasource;
            [self.navigationController pushViewController:blackList animated:YES];
        }else{
            _isDel = YES;
            [self.collectionView reloadData];
        }
    }else{
        if (indexPath.row < self.datasource.count) {
            [self.datasource removeObjectAtIndex:indexPath.row];
            [self.collectionView reloadData];
        }else if(indexPath.row == self.datasource.count){
            NIMSelectBlackListVC *blackList = [[NIMSelectBlackListVC alloc] init];
            blackList.delegate = self;
            blackList.showSelected = NO;
            blackList.selectedUsers = self.datasource;
            [self.navigationController pushViewController:blackList animated:YES];
        }
        
    }
    
}


-(void)selectListViewController:(NIMSelectBlackListVC *)viewController didSelectUsers:(NSArray *)users userNames:(NSArray *)userNames
{
    _isDel = NO;
    [self.datasource addObjectsFromArray:users];
    [self.collectionView reloadData];
}

-(void)qb_rightButtonAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *list = [self.datasource componentsJoinedByString:@","];
    [[NIMMomentsManager sharedInstance] settingBlacknotcarelistModifyRQ:_listType list:list];
}

-(void)recvSetBlack:(NSNotification *)noti
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    id object = noti.object;
    if(object){
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
            return;
        }else{
            if (_listType == List_Type_Black) {
                [NIMMomentsManager sharedInstance].setItem.blackList = [self.datasource componentsJoinedByString:@","];
            }else{
                [NIMMomentsManager sharedInstance].setItem.notCareList = [self.datasource componentsJoinedByString:@","];
                [[NIMMomentsManager sharedInstance] deleteMomentsInNotCare:[self.datasource componentsJoinedByString:@","]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:nil];
    }
}


-(UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [self.view addSubview:self.collectionView];
        //注册Cell
        [self.collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = @[].mutableCopy;
    }
    return _datasource;
}

@end
