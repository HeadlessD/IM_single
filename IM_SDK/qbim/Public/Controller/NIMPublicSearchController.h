//
//  NIMPublicSearchController.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMViewController.h"

@interface NIMPublicSearchController : NIMViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)IBOutlet UITableView *m_tableView;
@property (nonatomic,strong) UISearchBar *m_searchBar;
@property (nonatomic,strong) NSString    *m_searchString;
@end
