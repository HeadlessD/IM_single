//
//  NIMBusinessOperationBox.m
//  qbnimclient
//
//  Created by 秦雨 on 17/11/21.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBusinessOperationBox.h"
#import "NIMGlobalProcessor.h"

@implementation NIMBusinessOperationBox
SingletonImplementation(NIMBusinessOperationBox)

-(void)getFreeWaiter:(int64_t)bid wid_list:(NSArray *)wid_list
{
    [[NIMGlobalProcessor sharedInstance].businessProcessor getFreeWaiter:bid wid_list:wid_list];
}

-(void)setBusinessInfo:(SSIMBusinessModel *)info
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:10];
    NSArray *wids = info.waiters;
    for (NSDictionary *dict in wids) {
        int64_t wid = [[dict objectForKey:@"wid"] longLongValue];
        NSString *name = [dict objectForKey:@"widname"];
        [list addObject:@(wid)];
        NWaiterEntity *waiterEntity = [NWaiterEntity findFirstWithBid:info.bid wid:wid];
        if (waiterEntity == nil) {
            waiterEntity = [NWaiterEntity NIM_createEntity];
            waiterEntity.bid = info.bid;
            waiterEntity.wid = wid;
        }
        waiterEntity.name = name;
    }
    NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:info.bid];
    if (business == nil) {
        business = [NBusinessEntity NIM_createEntity];
        business.bid = info.bid;
    }
    business.name = info.name;
    business.avatar = info.avatar;
    business.wids = list;
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    //[[NIMGlobalProcessor sharedInstance].businessProcessor setBusinessInfo:info];
}

-(void)getBusinessInfo:(int64_t)sellerid
{
    [[NIMGlobalProcessor sharedInstance].businessProcessor getBusinessInfo:sellerid];
}

-(NSDictionary *)getJsonInfoByBusinessModel:(id)model
{
    NSDictionary *dict = nil;
    if ([model isKindOfClass:[SSIMProductModel class]])
    {
        SSIMProductModel *pModel = model;
        dict = @{@"product_id":pModel.product_id?:@"",
                 @"product_url":pModel.product_url?:@"",
                 @"product_name":pModel.product_name?:@"",
                 @"product_title":pModel.product_title?:@"",
                 @"product_desc":pModel.product_desc?:@"",
                 @"main_img":pModel.main_img?:@"",
                 @"product_price":pModel.product_price?:@"",
                 @"source_img":pModel.source_img?:@"",
                 @"source_txt":pModel.source_txt?:@"",
                 @"stock_num":pModel.stock_num?:@""};
    }else if ([model isKindOfClass:[SSIMOrderModel class]])
    {
        SSIMOrderModel *oModel = model;
        dict = @{@"order_id":oModel.order_id?:@"",
                 @"order_status":oModel.order_status?:@"",
                 @"order_title":oModel.order_title?:@"",
                 @"order_price":oModel.order_price?:@"",
                 @"status":oModel.stateVale?:@"",
                 @"buyer_id":oModel.buyer_id?:@"",
                 @"order_num":oModel.order_num?:@"",
                 @"order_pay":oModel.order_pay?:@"",
                 @"order_img":oModel.order_img?:@"",
                 @"order_num":oModel.order_num?:@"",
                 @"order_url":oModel.order_url?:@"",
                 @"order_list_desc":oModel.order_list_desc?:@"",
                 @"refund_amount":oModel.refund_amount?:@"",
                 @"refund_id":oModel.refund_id?:@"",
                 @"refund_order":@(oModel.refund_order)?:@"",
                 @"order_source_txt":oModel.order_source_txt?:@"",
                 @"order_source_img":oModel.order_source_img?:@""};
    }
    return dict;
}
@end
