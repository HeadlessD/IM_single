//
//  NIMQWTListView.m
//  Zhyq
//
//  Created by zhangtie on 14-1-22.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import "NIMQWTListView.h"
#import "NIMTSectionItem.h"
#import "NIMTTableViewHeaderControl.h"
#import "NIMWTErrorView.h"
#import "NIMTNoDataView.h"

@interface NIMQWTListView ()<UITableViewDataSource, UITableViewDelegate, NIMQBTableViewCellDelegate, NIMWTErrorViewDelegate>
{
    UIImageView             *_tableIndexTitleView;
    UILabel                 *_tableIndexTitleLabel;
    NSTimer                 *_tableIndexTitleTimer;
    
    UITableView *_tableList;
    
    NSMutableArray          *_sections;
}



@end

@implementation NIMQWTListView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"qb_dataSource" context:NULL];
    RELEASE_SAFELY(_tableIndexTitleView);
    RELEASE_SAFELY(_tableIndexTitleLabel);
    RELEASE_SAFELY(_tableIndexTitleTimer);
    RELEASE_SAFELY(_headers);
    RELEASE_SAFELY(_sections);
    _tableList.delegate     = nil;
    _tableList.dataSource   = nil;
    RELEASE_SAFELY(_tableList);
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setInit];
        [_tableList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_width);
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
        }];
        
        
        
    }
    return self;
}

- (void)setInit
{
//    [self setSeparatorColor:_RGB_A(30, 30, 30, 1.0)];
    self.isOnlyShowOneSection   = YES;
    self.defaultSelectedSection = 0;
    self.isNeedHeader       = NO;
    self.isCanStretch       = NO;
    self.isNeedSearchIndex  = NO;
//    self.isNeedDefaultStretch = YES;
    
    self.arrayOfCharacters = [[NSMutableArray alloc] initWithObjects:
                              //                                    UITableViewIndexSearch,
                              @"A", @"B", @"C", @"D", @"E", @"F", @"G",
                              @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                              @"O", @"P", @"Q",       @"R", @"S", @"T",
                              @"U", @"V", @"W",       @"X", @"Y", @"Z",
                              nil];
    
//    self.cellIndentify = [NSString stringWithFormat:@"str_cell_%@_indentify", NSStringFromClass([self class])];
    [self addSubview:self.tableList];
    [self setBackgroundColor:[SSIMSpUtil getColor:@"F1F1F1"]];
    [self setExtraCellLineHidden];
    [self addObserver:self forKeyPath:@"qb_dataSource" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

    
    
}

- (void)showHeader:(BOOL)bshow
{
    if(bshow)
    {
//        [self addSubview:self.qbHeadRefreshView];
//        self.qbHeadRefreshView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
//        self.qbHeadRefreshView.scrollView = self.tableList;
    }
    [super showHeader:bshow];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setInit];
    
    [_tableList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
    }];
}

-(void)setExtraCellLineHidden
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [self.tableList setTableFooterView:view];
    RELEASE_SAFELY(view);
}

- (void)reloadTable
{
    [self.tableList reloadData];
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style
{
    [self.tableList setSeparatorStyle:style];
}

- (void)setSeparatorColor:(UIColor*)color
{
    [self.tableList setSeparatorColor:color];
}

- (void)deleteIndexPaths:(NSArray*)indexPaths
{
    [self.tableList deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)isStretchInSection:(NSInteger)section
{
    if([_sections count] >section)
    {
        NIMTSectionItem *item = [_sections objectAtIndex:section];
        return !item.IsHidden;
    }
    return NO;
}

#pragma mark == UITablevViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(!self.dataSource)
//    {
//        return 0;
//    }
//    else
//    {
//        return [self.dataSource count];
//    }
    
    if(!self.qb_dataSource)
    {
        return 0;
    }
    else
    {
        if([self.headers count] > 1)
        {
        
            NIMTSectionItem* item = [_sections objectAtIndex:section];
            if(item.IsHidden)
            {
                return 0;
            }
            else
            {
                NSArray *datas = [self.qb_dataSource objectAtIndex:section];
                if(!datas)
                {
                    return 0;
                }
                else
                {
                    return [datas count];
                }
            }
        }
        else
        {
            return [self.qb_dataSource count];
        }
    }
}

- (Class)getCellClass
{
    return [_delegate getCellClass];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self getCellClass] getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL callBack = @selector(didSelectedRowWithData:atIndexPath:);
    
    id data      = nil;
    if([self.headers count] > 1)
    {
        data     = [self.qb_dataSource objectAtIndex:indexPath.section];
    }
    else
    {
        data     = [self.qb_dataSource objectAtIndex:indexPath.row];
    }
    if(_delegate && [_delegate respondsToSelector:callBack])
    {
        [_delegate didSelectedRowWithData:data atIndexPath:indexPath];
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self getCellIndentify]];

    if(!cell)
    {
        NSString *t_xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self getCellClass]) ofType:@"nib"];
        if(t_xibPath &&  [[NSFileManager defaultManager] fileExistsAtPath:t_xibPath])
        {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self getCellClass]) owner:nil options:nil];
            if([cells count] <= 0)
            {
                cell = [[[self getCellClass] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIndentify]];
            }
            else
            {
                cell = cells[0];
            }
        }
        else
        {
            cell = [[[self getCellClass] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIndentify]];
        }
    }
    
    if(indexPath.row % 2 == 1 && self.isNeedCellIntervalBackground)
    {
        [cell setBackgroundColor:[SSIMSpUtil getColor:@"f0f0f0"]];
    }

    if([cell isKindOfClass:[NIMQBTableViewCell class]])
    {
        NIMQBTableViewCell *qb_cell    = (NIMQBTableViewCell*)cell;
        qb_cell.delegate            = self;
    }
    
    NSInteger t_sectionNum          = [tableView.dataSource numberOfSectionsInTableView:tableView];
    if(t_sectionNum > 1)
    {
        NSInteger t_currentSection  = indexPath.section;
        NSInteger t_currentRow      = indexPath.row;
        NSArray *sectionInfos       = [self.qb_dataSource objectAtIndex:t_currentSection];
        SEL updateUISelector        = @selector(updateUIWithModel:);
        if([cell isKindOfClass:[NIMQBTableViewCell class]])
        {
            NIMQBTableViewCell *qb_cell = (NIMQBTableViewCell*)cell;
            if(t_currentRow < [sectionInfos count])
            {
                NIMBaseDataModel *cellInfo = sectionInfos[t_currentRow];
                if([cell respondsToSelector:updateUISelector])
                [qb_cell updateUIWithModel:cellInfo];
            }
        }
        else
        {
            
        }
    }
    else
    {
        NIMBaseDataModel *info  = [self.qb_dataSource objectAtIndex:indexPath.row];
        SEL updateUISelector    = @selector(updateUIWithModel:);
        if([cell isKindOfClass:[NIMQBTableViewCell class]])
        {
            NIMQBTableViewCell *qb_cell = (NIMQBTableViewCell*)cell;
            if([cell respondsToSelector:updateUISelector])
                [qb_cell updateUIWithModel:info];
            //        [cell performSelector:updateUISelector withObject:info];
        }
    }
    return cell;
    
}

#pragma mark -- tableTitleIndexs
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.isNeedSearchIndex)
    {
        return self.arrayOfCharacters;
    }
    else
    {
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

	NSInteger retPos = -1; /*无效的位置*/
    if(!self.isNeedSearchIndex)
    {
        return retPos;
    }
    
	if (title == UITableViewIndexSearch)
    {
		[tableView setContentOffset:CGPointMake(0, 0) animated:NO];
	}
	else
    {
		[self showIndexTitles:title index:index];
        
        NSInteger count = 0;
        
        for(NSString *character in self.arrayOfCharacters)
        {
            
            if([character isEqualToString:title])
            {
                
                return count;
                
            }
            
            count ++; 
            
        }
        return  count;
        
        
	}
    
	return retPos;
}

- (void)showIndexTitles:(NSString *)title index:(NSInteger)index
{
	if (_tableIndexTitleTimer != nil && [_tableIndexTitleTimer isValid])
    {
		[_tableIndexTitleTimer invalidate];
		_tableIndexTitleTimer = nil;
	}
    
	if (_tableIndexTitleView == nil)
    {
		UIImage * image      = IMGGET(@"tableview_title_index_bg.png");
		_tableIndexTitleView = [[UIImageView alloc] initWithImage:image];
        _CLEAR_BACKGROUND_COLOR_(_tableIndexTitleView);
		CGSize superSize = self.bounds.size;
		float x = (superSize.width  - image.size.width) / 2;
		float y = (superSize.height - image.size.height) / 2;
		[_tableIndexTitleView setFrame:CGRectMake(x, y, image.size.width, image.size.height)];
		[self addSubview:_tableIndexTitleView];
        
		UILabel * label = [[UILabel alloc] initWithFrame:_tableIndexTitleView.bounds];
        _CLEAR_BACKGROUND_COLOR_(label);
		[label setTextAlignment:ALIGN_CENTER];
		[label setTextColor:[UIColor whiteColor]];
		[label setFont:[UIFont systemFontOfSize:64]];
		[_tableIndexTitleView addSubview:label];
		_tableIndexTitleLabel = label;
	}
    
	[_tableIndexTitleView setHidden:NO];
	[_tableIndexTitleView setAlpha:1.0f];
    if(title == nil)
    {
        [_tableIndexTitleLabel setText:@""];
    }
    else
    {
       	[_tableIndexTitleLabel setText:title];
    }
    
    
	if (_tableIndexTitleTimer == nil)
    {
		_tableIndexTitleTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(hideTheIndexTitle:) userInfo:nil repeats:NO];
	}
}

- (void)hideTheIndexTitle:(id)params
{
	[_tableIndexTitleTimer invalidate];
	_tableIndexTitleTimer = nil;
    
	void (^animation)(void) = ^(void){
		[_tableIndexTitleView setAlpha:0.0f];
	};
	void (^animationEnd)(BOOL finished) = ^(BOOL finished){
		[_tableIndexTitleView setHidden:YES];
	};
	[UIView animateWithDuration:0.2 animations:animation completion:animationEnd];
}


#pragma mark -- tableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.isNeedHeader)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.isNeedHeader)
    {
        return nil;
    }
    
    NIMTTableViewHeaderControl *result = nil;
    DLog(@"section:%ld", (long)section);
    
    CGFloat height = [tableView.delegate tableView:tableView heightForHeaderInSection:section];
    
    result = _ALLOC_OBJ_WITHFRAME_(NIMTTableViewHeaderControl, _CGR(0.0f, 0.0f, self.bounds.size.width, height)) ;
//    result.backgroundColor = [UIColor blackColor];// [UIColor colorWithRed:180.0/255.0f green:180.0/255.0f blue:180.0/255.0f alpha:0.8];
    

    
    result.tag = section;
    [result addTarget:self action:@selector(headerIsTapEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [self qbTableView:tableView viewForHeaderInSection:section];
    if(view)
    {
        view.userInteractionEnabled = NO;
        [result addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.width.equalTo(result.mas_width);
            make.height.equalTo(result.mas_height);
        }];
        [view setNeedsLayout];
    }
    else
    {
        NSString* title = [self.headers objectAtIndex:section];
        [result setTitle:title];
    }
    return result;
    
}

- (UIView *)qbTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)setSectionHidden:(BOOL)hidden atIndex:(NSInteger)sectionIndex
{
    if(self.isNeedHeader)
    {
        NIMTSectionItem* item = (NIMTSectionItem*)[_sections objectAtIndex:sectionIndex];
        item.IsHidden = hidden;
    }
}

//如果外部有操作就不在内部reload,放到外部调用
-(void)headerIsTapEvent:(id)sender
{
    if(self.isCanStretch)
    {
        UIControl* nowConrol    = (UIControl*)sender;
        NSInteger secIndex      = nowConrol.tag;
        if(secIndex >= [_sections count])
        {
            return;
        }
        NIMTSectionItem* item       = (NIMTSectionItem*)[_sections objectAtIndex:secIndex];
        if(!self.isOnlyShowOneSection)
        {
            BOOL _bool              = item.IsHidden;
            item.IsHidden           = !_bool;
        }
        else
        {//只能选中一个
//            if(item.IsHidden)
//            {
                for (NIMTSectionItem *subItem in _sections)
                {
                    subItem.IsHidden = (!(subItem == item));
                }
//            }
        }
        
        SEL callBack = @selector(headerClickAtIndex:isHidden:);
        if(_delegate && [_delegate respondsToSelector:callBack])
        {
            [_delegate headerClickAtIndex:secIndex isHidden:item.IsHidden];
            //        [_delegate performSelector:callBack withObject:(id)secIndex withObject:(id)item.IsHidden];
        }
        else
        {
            [self reloadTable];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([@"qb_dataSource" isEqualToString:keyPath])
    {
        [_sections removeAllObjects];
        //        [btn_selects removeAllObjects];
        NSArray* newDataSource = [change objectForKey:@"new"];

        for(int i=0; i<[newDataSource count]; ++i)
        {
            NIMTSectionItem* item   = [[NIMTSectionItem alloc]init];
            item.sectionIndex   = i;
            if(self.isOnlyShowOneSection)
            {
                item.IsHidden       = !(i == self.defaultSelectedSection);
            }
            else
            {
                //                if(self.isNeedDefaultStretch)
                {
                    item.IsHidden       = !self.isNeedDefaultStretch;
                }
                
            }
            item.IsSelectedAll  = NO;
            [_sections addObject:item];
            RELEASE_SAFELY(item);
        }
    }
}

#pragma mark -- getter
_GETTER_BEGIN(UITableView, tableList)
{
    _CREATE_TABLEVIEW(_tableList, self.bounds, UITableViewStylePlain);
    
//    [_tableList setTranslatesAutoresizingMaskIntoConstraints:YES];

}
_GETTER_END(tableList)

- (UIScrollView*)mainList
{
    return self.tableList;
}

- (void)setIsCanStretch:(BOOL)isCanStretch
{
    _isCanStretch = isCanStretch;
    
    if(isCanStretch)
    {
        [self removeObserver:self forKeyPath:@"qb_dataSource" context:NULL];
        
        _sections = _ALLOC_OBJ_(NSMutableArray);
        
        [self addObserver:self forKeyPath:@"qb_dataSource" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)setIsCanEdit:(BOOL)isCanEdit
{
    _isCanEdit = isCanEdit;
    
//    [self.tableList setEditing:YES animated:YES];
}

- (void)setDefaultSelectedSection:(NSInteger)defaultSelectedSection
{
    _defaultSelectedSection = defaultSelectedSection;
    
    _isNeedDefaultStretch   = NO;
    
    for(int i=0; i<[_sections count]; ++i)
    {
        NIMTSectionItem* item = _sections[i];
        item.IsHidden        = !(i == defaultSelectedSection);
    }
    
    [self reloadTable];
}

- (void)setIsNeedDefaultStretch:(BOOL)isNeedDefaultStretch
{
    //        [btn_selects removeAllObjects];
    _isNeedDefaultStretch = isNeedDefaultStretch;
    for(int i=0; i<[_sections count]; ++i)
    {
        NIMTSectionItem* item = _sections[i];
        item.IsHidden        = !self.isNeedDefaultStretch;
    }
    
    [self reloadTable];
}

- (int)openSections
{
    for (NIMTSectionItem *item in _sections)
    {
        if(item.IsHidden == NO)
        {
            return item.sectionIndex;
        }
    }
    return 0;
}

#pragma mark -- NoDataView
- (void)qb_showNoDataView:(BOOL)show title:(NSString*)title
{
    if(show)
    {
        [self addSubview:self.qbm_viewNoData];
        [self.qbm_viewNoData.labError setText:title];
        [self.qbm_viewNoData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(200));
            make.height.equalTo(@(190));
            
        }];
    }
    else
    {
        [_qbm_viewNoData removeFromSuperview];
    }
}

#pragma mark -- ErrorView
- (void)qb_showErrorView:(BOOL)show
{
    if(show)
    {
        [self addSubview:self.qbm_viewError];
        [self.qbm_viewError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(200));
            make.height.equalTo(@(190));
            
        }];
    }
    else
    {
        [_qbm_viewError removeFromSuperview];
    }
}

- (void)doErrHandle:(NIMWTErrorView *)sender
{
    [self refreshData];
}

_GETTER_BEGIN(NIMWTErrorView, qbm_viewError)
{
    _qbm_viewError = _ALLOC_OBJ_(NIMWTErrorView);
    _qbm_viewError.delegate = self;
}
_GETTER_END(qbm_viewError)

_GETTER_BEGIN(NIMTNoDataView, qbm_viewNoData)
{
    _qbm_viewNoData = _ALLOC_OBJ_(NIMTNoDataView);
//    _qbm_viewNoData.delegate = self;
}
_GETTER_END(qbm_viewNoData)


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
