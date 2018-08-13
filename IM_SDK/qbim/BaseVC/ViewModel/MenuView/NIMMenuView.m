//
//  NIMMenuView.m
//  QianbaoIM
//
//  Created by Rain on 14-9-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMMenuView.h"
#import "NIMMenuViewCell.h"

@interface NIMMenuView()<UITableViewDataSource,UITableViewDelegate>
@property BOOL isOpen;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) Class tabCell;

@end

@implementation NIMMenuView
- (id)initWithSourse:(NSArray *)dataSource andCell:(Class)cell
{
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
        self.tabCell = cell;
        self.isOpen = NO;
        UITableView *tab = [[UITableView alloc] init];
        tab.translatesAutoresizingMaskIntoConstraints = NO;
        tab.delegate = self;
        tab.dataSource = self;
        tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.mainTableView = tab;
        [self addSubview:tab];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_mainTableView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_mainTableView)]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mainTableView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(_mainTableView)]];
        
        [_mainTableView reloadData];
        
    }
    return self;
}

#pragma mark- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"identifier";
    NIMMenuViewCell *cell = (NIMMenuViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[_tabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id obj = [_dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]])
    {
        [(NIMMenuViewCell *)cell setCellValue:obj];
    }
    else if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSString *dictKey = [[obj allKeys] lastObject];
        [(NIMMenuViewCell *)cell setCellValue:[obj objectForKey:dictKey]];
    }
    else
    {
        DBLog(@"数据源配置错误");
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectIndex:)])
    {
        [_mainTableView reloadData];
        [self setCellTitleColor:indexPath];
        [_delegate selectIndex:indexPath.row];
    }
}

- (void)setCellTitleColor:(NSIndexPath *)indexPath
{
    NIMMenuViewCell *cell = (NIMMenuViewCell *)[_mainTableView cellForRowAtIndexPath:indexPath];
    [cell setCellTitleColor:[SSIMSpUtil getColor:@"FF5A00"]];
}

@end
