//
//  NIMPublicFansTableViewCell.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/24.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicFansTableViewCell.h"
#import "NIMVcardCollectionViewCell.h"

@implementation NIMPublicFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataSource:(NIMPublicInfoModel *)model
{
    self.fansArry = model.publicInfoModel.publicInfoFans;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
    [self.collectionView reloadData];
}
#pragma mark config
- (void)makeConstraints{
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number = self.fansArry.count;
    if (number >=16) {
        number = 16;
    }
    return number;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QBPublicFansID" forIndexPath:indexPath];
     NSString *imageStr = nil;
    if (indexPath.row < self.fansArry.count) {
        QBPublicInfoFanModel *model = [self.fansArry objectAtIndex:indexPath.row];
        imageStr = model.avatarPic;
    }
    [cell updateConstraints];
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        float length = floorf(([UIScreen mainScreen].bounds.size.width-30-35)/8);
        flowLayout.itemSize = CGSizeMake(length, length);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.userInteractionEnabled = NO;
//        _collectionView = [[UICollectionView alloc] init];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate =self;
        [_collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:@"QBPublicFansID"];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSArray *)fansArry
{
    if (!_fansArry) {
        _fansArry = [NSArray new];
    }
    return _fansArry;
}


@end
