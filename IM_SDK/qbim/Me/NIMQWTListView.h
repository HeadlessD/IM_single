//
//  NIMQWTListView.h
//  Zhyq
//
//  Created by zhangtie on 14-1-22.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import "NIMQWTBaseRefreshView.h"
#import "NIMQBTableViewCell.h"
#import "NIMWTErrorView.h"
#import "NIMTNoDataView.h"

@class NIMBaseDataModel;
@protocol NIMQWTListViewProtocol <NSObject>

@required
- (Class)getCellClass;

@optional
- (NSString*)getCellIndentify;

@optional

@end

@interface NIMQWTListView : NIMQWTBaseRefreshView<NIMQWTListViewProtocol, NIMQBTableViewCellDelegate>

_PROPERTY_NONATOMIC_RETAIN(NSArray,                 qb_dataSource);

_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isOnlyShowOneSection);        //一次只能展示一个section, default is NO

_PROPERTY_NONATOMIC_ASSIGN(NSInteger,               defaultSelectedSection);        //isOnlyShowOneSection为yes时候有效

_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isCanEdit); //行是否可以编辑default is NO

_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isNeedCellIntervalBackground); //奇偶行的背景色差

_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isNeedSearchIndex);     //是否需要右侧索引提示

_PROPERTY_NONATOMIC_RETAIN(NSArray,                 arrayOfCharacters);     //右侧索引提示

_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isNeedHeader);          //是否需要header，default is NO
_PROPERTY_NONATOMIC_RETAIN(NSArray,                 headers);
_PROPERTY_NONATOMIC_READONLY(int,                   openSections);
_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isCanStretch);          //是否能伸缩default is NO,在isNeedHeader为YES情况下有效
_PROPERTY_NONATOMIC_ASSIGN(BOOL,                    isNeedDefaultStretch);          //是否默认全伸展 default is NO;

_PROPERTY_NONATOMIC_READONLY(UITableView,           *tableList);

//_PROPERTY_NONATOMIC_RETAIN(NSString,            cellIndentify);

@property (nonatomic, strong) NIMWTErrorView      *qbm_viewError;
@property (nonatomic, strong) NIMTNoDataView     *qbm_viewNoData;

- (void)reloadTable;

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style;

- (void)setSeparatorColor:(UIColor*)color;

- (void)showIndexTitles:(NSString *)title index:(NSInteger)index;

- (void)setSectionHidden:(BOOL)hidden atIndex:(NSInteger)sectionIndex;

- (void)deleteIndexPaths:(NSArray*)indexPaths;

- (BOOL)isStretchInSection:(NSInteger)section;

- (UIView *)qbTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

#pragma mark -- ErrorView
- (void)qb_showErrorView:(BOOL)show;
#pragma mark -- NoDataView
- (void)qb_showNoDataView:(BOOL)show title:(NSString*)title;

@end
