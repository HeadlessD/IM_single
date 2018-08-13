//
//  NIMEditInfoCellModel.h
//  QianbaoIM
//
//  Created by liyan on 9/22/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMBaseDataModel.h"

@interface NIMEditInfoCellModel : NIMBaseDataModel
{
    id           _value;
    id           _updateValue;
    id           _showValue;
}
@property (nonatomic, strong)NSString   *title;

@property (nonatomic, strong)id           value;       //初始值
@property (nonatomic, strong)id           updateValue; //修改过但没有提交过的值
@property (nonatomic, strong)NSString    *showValue;   //展示的值
@property (nonatomic, assign)BOOL        isChange;     //是否修改
@property (nonatomic, strong)Class       vcClass;
@property (nonatomic, assign)BOOL        isNecessarily;     //是否修改



- (BOOL)needSumbit;

@end


@interface QBEditSexInfoCellModel : NIMEditInfoCellModel

@end

@interface QBEditLocationInfoCellMdoel : NIMEditInfoCellModel

@end

@interface QBEditHometownInfoCellMdoel : NIMEditInfoCellModel

@end
@interface QBEditSignTimeInfoCellMdoel : NIMEditInfoCellModel

@end

@interface QBEditOftemPlaceInfoCellModel:NIMEditInfoCellModel

@end

@interface QBEditPayTypeInfoCellModel:NIMEditInfoCellModel

@end
