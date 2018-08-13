//
//  NIMQBTableViewCell.h
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELL_Line_HEIGHT        _LINE_HEIGHT_1_PPI

@class NIMBaseDataModel;
@protocol NIMQBTableViewCellDelegate <NSObject>

@optional
- (void)updateUIWithModel:(id)data;

+ (CGFloat)getHeight;

+ (CGFloat)getHeightWithDataModel:(id)model;

+ (CGFloat)getHeightWithDataModel:(id)model withSuperWidth:(CGFloat)t_superWidth;

//cell中单击按钮事件
- (void)tableCellOpClicked:(id)sender;

#pragma mark -- style
- (void)qbf_setCellUIStyle;

@end

@interface NIMQBTableViewCell : UITableViewCell<NIMQBTableViewCellDelegate>

@property(nonatomic, weak)id<NIMQBTableViewCellDelegate> delegate;

_PROPERTY_NONATOMIC_RETAIN(UIImageView, qbm_taskDetailImageView);

- (void)qb_setCellBgColor:(UIColor*)color;

- (void)qb_showBottomLine:(BOOL)show;

//- (void)qb_setLineWholeWidth:(BOOL)bwhole;

- (void)qb_setLineWidthLeftValue:(CGFloat)left;
- (void)qb_setLineWidthLeftValue:(CGFloat)left height:(CGFloat)height;

- (void)qb_setLineWidthLeft:(MASViewAttribute*)left;
- (void)qb_setLineWidthLeft:(MASViewAttribute*)left height:(CGFloat)height;
- (void)qb_setLineColor:(UIColor*)bColor;

@end
