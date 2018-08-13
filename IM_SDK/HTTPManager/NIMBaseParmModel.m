//
//  BaseParmModel.m
//  IOS7Test
//
//  Created by zhangtie on 13-11-6.
//  Copyright (c) 2013年 zhangtie. All rights reserved.
//

#import "NIMBaseParmModel.h"

@interface NIMBaseParmModel ()

@property(nonatomic, retain)NSMutableDictionary *parmDict;

@end

@implementation NIMBaseParmModel

- (void)dealloc
{
    RELEASE_SAFELY(_parmDict);
    RELEASE_SUPER_DEALLOC;
}

- (void)setParm:(id)parmVal forKey:(NSString*)parmName
{
    if(nil == parmName)
        return;
    
    SET_PARAM(parmVal, parmName, self.parmDict);

}

- (void)removeParmForKey:(NSString*)parmKey
{
    if(!parmKey)
    {
        return;
    }
    else
    {
        [self.parmDict removeObjectForKey:parmKey];
    }
}

- (id)parmValForKey:(NSString*)key
{
    if(!key)
    {
        return nil;
    }
    else
    {
        return [self.parmDict objectForKey:key];
    }
}

- (NSDictionary*)parm2jsonObj
{
    return _parmDict;
}

+ (NIMBaseParmModel*)parmFromDict:(NSDictionary*)dict
{
    NIMBaseParmModel *parm = [NIMBaseParmModel parmObjNew];
    
    [parm.parmDict addEntriesFromDictionary:dict];
    
    return parm;
}

#pragma mark -- getter
- (NSMutableDictionary*)parmDict
{
    if(!_parmDict)
    {
        _parmDict = [[NSMutableDictionary alloc]init];
        
    }
    return _parmDict;
}

//+ (id)parmObj
//{
//    NIMBaseParmModel *parm = _ALLOC_OBJ_(NIMBaseParmModel);
//    return [parm autorelease];
//}

+ (id)parmObjNew
{
    return [[[self class] alloc]init];
}


@end
