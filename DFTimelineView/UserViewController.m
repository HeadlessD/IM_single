//
//  UserTimelineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UserViewController.h"
#import "DFDetailViewController.h"
@implementation UserViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvQueryUser:) name:NC_USER_QUERY object:nil];
//    [self initData];
    [self setHeader];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NIMMomentsManager sharedInstance].user_arr removeAllObjects];
    [[NIMMomentsManager sharedInstance].user_dict removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

-(void) setHeader
{
    NSString *coverUrl = USER_ICON_URL(_userid);
    [self setCover:coverUrl];
    
    [self setUserAvatar:USER_ICON_URL(_userid)];
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:_userid];

    [self setUserNick:vcard.defaultName];
    
    [self setUserSign:vcard.signature];
}



-(void) initData
{
    DFTextImageUserLineItem *item = [[DFTextImageUserLineItem alloc] init];
    item.itemId = 1111;
    item.ts = 1444902955586;
    item.cover = @"http://file-cdn.datafans.net/temp/11.jpg_200x200.jpeg";
    item.photoCount = 5;
    item.text = @"我说你二你就二";
    [self addItem:item];
    
    
    DFTextImageUserLineItem *item2 = [[DFTextImageUserLineItem alloc] init];
    item2.itemId = 11222;
    item2.ts = 1444902951586;
    item2.text = @"阿里巴巴（1688.com）是全球企业间电子商务的著名品牌，为数千万网商提供海量商机信息和便捷安全的在线交易市场，也是商人们以商会友、真实互动的社区平台 ...";
    
    [self addItem:item2];
    
    
    DFTextImageUserLineItem *item3 = [[DFTextImageUserLineItem alloc] init];
    item3.itemId = 22221111;
    item3.ts = 1444102855586;
    item3.cover = @"http://file-cdn.datafans.net/temp/15.jpg_200x200.jpeg";
    item3.photoCount = 8;
    [self addItem:item3];
    
    
    DFTextImageUserLineItem *item4 = [[DFTextImageUserLineItem alloc] init];
    item4.itemId = 7771111;
    item4.ts = 1442912955586;
    item4.cover = @"http://file-cdn.datafans.net/temp/19.jpg_200x200.jpeg";
    item4.photoCount = 6;
    [self addItem:item4];
    
    
    
    DFTextImageUserLineItem *item5 = [[DFTextImageUserLineItem alloc] init];
    item5.itemId = 9991111;
    item5.ts = 1442912945586;
    item5.cover = @"http://file-cdn.datafans.net/temp/14.jpg_200x200.jpeg";
    item5.photoCount = 2;
    item5.text = @"京东JD.COM-专业的综合网上购物商城，销售超数万品牌、4020万种商品，http://jd.com 囊括家电、手机、电脑、服装、图书、母婴、个护、食品、旅游等13大品类。秉承客户为先的理念，京东所售商品为正品行货、全国联保、机打发票。@刘强东";
    [self addItem:item5];
}



-(void) refresh
{
    [[NIMMomentsManager sharedInstance] sendQueryMomentsRQ:_userid endTime:[NIMBaseUtil GetServerTime]/1000];
//    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [self endRefresh];
//    });
}

-(void) loadMore
{
    static int64_t time = 0;
    NSArray *arr = [[NIMMomentsManager sharedInstance] user_arr];
    DFBaseUserLineItem *item = arr.lastObject;
    if (time != item.ts) {
        time = item.ts;
        [[NIMMomentsManager sharedInstance] sendQueryMomentsRQ:_userid endTime:item.ts-1];
    }else{
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self endRefresh];
    }
    
//    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [self endLoadMore];
//    });
}



-(void)onClickItem:(DFBaseUserLineItem *)item
{
    NSLog(@"click item: %lld", item.itemId);
    DFDetailViewController *detail = [DFDetailViewController new];
    detail.itemId = item.itemId;
    detail.userId = _userid;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)recvQueryUser:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            BOOL isRefresh = [object boolValue];
            if(isRefresh){
                [self.tableView reloadData];
            }
        }
    }else{
        
    }
    [self endRefresh];
}


@end
