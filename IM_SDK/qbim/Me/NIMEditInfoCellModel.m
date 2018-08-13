//
//  NIMEditInfoCellModel.m
//  QianbaoIM
//
//  Created by liyan on 9/22/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMEditInfoCellModel.h"

@implementation NIMEditInfoCellModel
@synthesize value =_value;
@synthesize updateValue = _updateValue;
@synthesize showValue = _showValue;
@synthesize isNecessarily = _isNecessarily;

- (void)setValue:(id)value
{
    if(_value != value)
    {
        _value = value;
    }
    
    
    if([value isKindOfClass:[NSString class]])
    {
        self.showValue = value;
        _updateValue = [value  copy];
    }
    else if([value isKindOfClass:[NSArray class]])
    {
        NSArray *arr =  (NSArray *) value;
        
        NSMutableString *mSTR = [NSMutableString stringWithString:@""];
        for (NSString *sSV in arr)
        {
            NSString *_sSV = _IM_FormatStr(@" %@",sSV);
            [mSTR appendString:_sSV];
        }
        self.showValue = mSTR;
        _updateValue = [value  mutableCopy];
    }
    else if ([value isKindOfClass:[UIImage class]])
    {
        self.showValue = value;
        _updateValue = [value  copy];
    }
}

- (void)setUpdateValue:(id)updateValue
{
    if(_updateValue != updateValue)
    {
        _updateValue = updateValue;
    }
    
    if([updateValue isKindOfClass:[NSString class]])
    {
        self.showValue = updateValue;
    }
    else if([updateValue isKindOfClass:[NSArray class]])
    {
        NSArray *arr =  (NSArray *) updateValue;
        
        NSMutableString *mSTR = [NSMutableString stringWithString:@""];
        for (NSString *sSV in arr)
        {
            NSString *_sSV = _IM_FormatStr(@" %@",sSV);
            [mSTR appendString:_sSV];
        }
        self.showValue = mSTR;
    }
    else if ([updateValue isKindOfClass:[UIImage class]])
    {
        self.showValue = updateValue;
    }
}


- (BOOL)needSumbit
{
    if([self.value isKindOfClass:[NSString class]])
    {
        if([self.updateValue isEqualToString:self.value])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else  if([self.value isKindOfClass:[NSArray class]])
    {
        
        if([self.value count] != [self.updateValue count])
        {
            return YES;
        }
        else
        {
            int count = [self.value count];
            for (int i = 0; i < count; i++)
            {
                NSString *value = [self.value objectAtIndex:i];
                NSString *updateValue = [self.updateValue objectAtIndex:i];
                if(![value isEqualToString:updateValue])
                {
                    return YES;
                }
            }
            return NO;
        }
        
        
    }
    else  if([self.value isKindOfClass:[UIImage class]])
    {
        return NO;
    }
    else
    {
        if(self.value  == nil && self.updateValue != nil)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

@end

@implementation QBEditSexInfoCellModel

- (void)setValue:(id)value
{
    if(_value != value)
    {
        _value = value;
    }
    _updateValue = [value copy];

    if([value isEqualToString:USER_SEX_FEMALE])
    {
        
        _showValue = @"女";
    }
    else if([value isEqualToString:USER_SEX_MALE])
    {
        _showValue = @"男";
    }else{
        _showValue = @"";
    }
}

- (void)setUpdateValue:(id)updateValue
{
    if(_updateValue != updateValue)
    {
        _updateValue = updateValue;
    }
    
    if([_updateValue isEqualToString:USER_SEX_FEMALE])
    {
        
        _showValue = @"女";
    }
    else
    {
        _showValue = @"男";
    }
}


@end


@implementation QBEditLocationInfoCellMdoel

- (void)setValue:(id)value
{
    if(_value != value)
    {
        _value = value;
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        NSArray *arr =  (NSArray *) value;
        
        NSMutableString *mSTR = [NSMutableString stringWithString:@""];
        for (NSString *sSV in arr)
        {
            NSString *_sSV = _IM_FormatStr(@" %@",sSV);
            [mSTR appendString:_sSV];
        }
        if(mSTR.length == 1)
        {
            self.showValue = @"未知";
            _updateValue =@[].mutableCopy;
        }
        else
        {
            self.showValue = mSTR;
            _updateValue = [value mutableCopy];
        }
        
    }
    else
    {
        self.showValue = @"未知";
        _updateValue =@[].mutableCopy;
        
    }
}
@end

@implementation QBEditHometownInfoCellMdoel

- (void)setValue:(id)value
{
    if(_value != value)
    {
        _value = value;
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        NSArray *arr =  (NSArray *) value;
        
        NSMutableString *mSTR = [NSMutableString stringWithString:@""];
        for (NSString *sSV in arr)
        {
            NSString *_sSV = _IM_FormatStr(@" %@",sSV);
            [mSTR appendString:_sSV];
        }
        if(mSTR.length == 1)
        {
            self.showValue = @"未知";
            _updateValue =@[].mutableCopy;
        }
        else
        {
            self.showValue = mSTR;
            _updateValue = [value mutableCopy];
        }
    }
    else
    {
        self.showValue = @"未知";
        _updateValue = @[].mutableCopy;
    }
}
@end

@implementation QBEditOftemPlaceInfoCellModel

@end

@implementation QBEditSignTimeInfoCellMdoel

@end


@implementation QBEditPayTypeInfoCellModel

@end
