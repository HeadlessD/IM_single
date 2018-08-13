//
//  ViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMainViewController.h"
#import "NIMSelfViewController.h"
#import "UserViewController.h"
#import "NIMMomentsManager.h"
@interface DFMainViewController ()
@property (nonatomic, strong) DFVideoLineItem *videoItem;
@end

@implementation DFMainViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友圈";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGetArticle:) name:NC_GET_ARTICLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSendArticle:) name:NC_SEND_ARTICLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];

    [self initData];
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([NIMMomentsManager sharedInstance].moment_arr.count==0) {
        [self initData];
    }else{
    }
    [self setHeader];

}


//朋友圈用户信息
-(void) setHeader
{
//    NSString *coverUrl = [NSString stringWithFormat:@"http://file-cdn.datafans.net/temp/12.jpg_%dx%d.jpeg", (int)self.coverWidth, (int)self.coverHeight];
    [self setCover:USER_ICON_URL(OWNERID)];
//    NSString *avatarUrl = [NSString stringWithFormat:@"http://file-cdn.datafans.net/avatar/1.jpeg_%dx%d.jpeg", (int)self.userAvatarSize, (int)self.userAvatarSize];
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:OWNERID];

    [self setUserAvatar:USER_ICON_URL(OWNERID)];
    
    [self setUserNick:[vcard defaultName]];
    
    [self setUserSign:vcard.signature];
}

-(void) initData
{
    [self.tableView.mj_header beginRefreshing];
//    NSArray *items = [[NIMMomentsManager sharedInstance] loadMomentData];
//
//    for (DFBaseLineItem *item in items) {
//        [self addItemTop:item];
//    }
    /*
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = 1;
    textImageItem.userId = 10086;
    textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    textImageItem.userNick = @"Allen";
    textImageItem.title = @"";
    textImageItem.text = @"你是我的小苹果 小苹果 我爱你 就像老鼠爱大米 18680551720 [亲亲]";
    
    NSMutableArray *srcImages = [NSMutableArray array];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/11.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/12.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/13.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/14.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/15.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/16.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/17.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/18.jpg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/temp/19.jpg"];
    
    textImageItem.srcImages = srcImages;
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/11.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/12.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/13.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/14.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/15.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/16.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/17.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/18.jpg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/temp/19.jpg_160x160.jpeg"];
    textImageItem.thumbImages = thumbImages;
    
    NSMutableArray *thumbPreviewImages = [NSMutableArray array];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/11.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/12.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/13.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/14.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/15.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/16.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/17.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/18.jpg_600x600.jpeg"];
    [thumbPreviewImages addObject:@"http://file-cdn.datafans.net/temp/19.jpg_600x600.jpeg"];
    textImageItem.thumbPreviewImages = thumbPreviewImages;
    
    textImageItem.location = @"中国 • 广州";
    textImageItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
    
    DFLineLikeItem *likeItem1_1 = [[DFLineLikeItem alloc] init];
    likeItem1_1.userId = 10086;
    likeItem1_1.userNick = @"Allen";
    [textImageItem.likes addObject:likeItem1_1];
    
    DFLineLikeItem *likeItem1_2 = [[DFLineLikeItem alloc] init];
    likeItem1_2.userId = 10088;
    likeItem1_2.userNick = @"奥巴马";
    [textImageItem.likes addObject:likeItem1_2];
    
    DFLineCommentItem *commentItem1_1 = [[DFLineCommentItem alloc] init];
    commentItem1_1.commentId = 10001;
    commentItem1_1.userId = 10086;
    commentItem1_1.userNick = @"习大大";
    commentItem1_1.text = @"精彩 大家鼓掌";
    [textImageItem.comments addObject:commentItem1_1];
    
    DFLineCommentItem *commentItem1_2 = [[DFLineCommentItem alloc] init];
    commentItem1_2.commentId = 10002;
    commentItem1_2.userId = 10088;
    commentItem1_2.userNick = @"奥巴马";
    commentItem1_2.text = @"欢迎来到美利坚";
    commentItem1_2.replyUserId = 10086;
    commentItem1_2.replyUserNick = @"习大大";
    [textImageItem.comments addObject:commentItem1_2];
    
    DFLineCommentItem *commentItem1_3 = [[DFLineCommentItem alloc] init];
    commentItem1_3.commentId = 10003;
    commentItem1_3.userId = 10010;
    commentItem1_3.userNick = @"神雕侠侣";
    commentItem1_3.text = @"呵呵";
    [textImageItem.comments addObject:commentItem1_3];
    
    [self addItem:textImageItem];
    */
//    DFTextImageLineItem *textImageItem2 = [[DFTextImageLineItem alloc] init];
//    textImageItem2.itemId = 2;
//    textImageItem2.userId = 10088;
//    textImageItem2.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
//    textImageItem2.userNick = @"奥巴马";
//    textImageItem2.title = @"发表了";
//    textImageItem2.text = @"京东JD.COM-专业的综合网上购物商城，销售超数万品牌、4020万种商品，http://jd.com 囊括家电、手机、电脑、服装、图书、母婴、个护、食品、旅游等13大品类。秉承客户为先的理念，京东所售商品为正品行货、全国联保、机打发票。@刘强东";
//
//    NSMutableArray *srcImages2 = [NSMutableArray array];
//    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/20.jpg"];
//    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/21.jpg"];
//    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/22.jpg"];
//    [srcImages2 addObject:@"http://file-cdn.datafans.net/temp/23.jpg"];
//    textImageItem2.srcImages = srcImages2;
//
//    NSMutableArray *thumbImages2 = [NSMutableArray array];
//    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/20.jpg_160x160.jpeg"];
//    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_160x160.jpeg"];
//    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/22.jpg_160x160.jpeg"];
//    [thumbImages2 addObject:@"http://file-cdn.datafans.net/temp/23.jpg_160x160.jpeg"];
//    textImageItem2.thumbImages = thumbImages2;
//
//    NSMutableArray *thumbPreviewImages2 = [NSMutableArray array];
//    [thumbPreviewImages2 addObject:@"http://file-cdn.datafans.net/temp/20.jpg_600x600.jpeg"];
//    [thumbPreviewImages2 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_600x600.jpeg"];
//    [thumbPreviewImages2 addObject:@"http://file-cdn.datafans.net/temp/22.jpg_600x600.jpeg"];
//    [thumbPreviewImages2 addObject:@"http://file-cdn.datafans.net/temp/23.jpg_600x600.jpeg"];
//    textImageItem2.thumbPreviewImages = thumbPreviewImages2;
//
//    DFLineLikeItem *likeItem2_1 = [[DFLineLikeItem alloc] init];
//    likeItem2_1.userId = 10086;
//    likeItem2_1.userNick = @"Allen";
//    [textImageItem2.likes addObject:likeItem2_1];
//
//    DFLineCommentItem *commentItem2_1 = [[DFLineCommentItem alloc] init];
//    commentItem2_1.commentId = 18789;
//    commentItem2_1.userId = 10088;
//    commentItem2_1.userNick = @"奥巴马";
//    commentItem2_1.text = @"欢迎来到美利坚";
//    commentItem2_1.replyUserId = 10086;
//    commentItem2_1.replyUserNick = @"习大大";
//    [textImageItem2.comments addObject:commentItem2_1];
//
//    DFLineCommentItem *commentItem2_2 = [[DFLineCommentItem alloc] init];
//    commentItem2_2.commentId = 234657;
//    commentItem2_2.userId = 10010;
//    commentItem2_2.userNick = @"神雕侠侣";
//    commentItem2_2.text = @"大家好";
//    [textImageItem2.comments addObject:commentItem2_2];
//
//    [self addItem:textImageItem2];
//
//    DFTextImageLineItem *textImageItem3 = [[DFTextImageLineItem alloc] init];
//    textImageItem3.itemId = 3;
//    textImageItem3.userId = 10088;
//    textImageItem3.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
//    textImageItem3.userNick = @"奥巴马";
//    textImageItem3.title = @"发表了";
//    textImageItem3.text = @"京东JD.COM-专业的综合网上购物商城";
//
//    NSMutableArray *srcImages3 = [NSMutableArray array];
//    [srcImages3 addObject:@"http://file-cdn.datafans.net/temp/21.jpg"];
//    textImageItem3.srcImages = srcImages3;
//
//    NSMutableArray *thumbImages3 = [NSMutableArray array];
//    [thumbImages3 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_640x420.jpeg"];
//    textImageItem3.thumbImages = thumbImages3;
//
//    NSMutableArray *thumbPreviewImages3 = [NSMutableArray array];
//    [thumbPreviewImages3 addObject:@"http://file-cdn.datafans.net/temp/21.jpg_600x600.jpeg"];
//    textImageItem3.thumbPreviewImages = thumbPreviewImages3;
//
//    textImageItem3.width = 640;
//    textImageItem3.height = 360;
//
//    textImageItem3.location = @"金色洗脚城";
//
//    DFLineCommentItem *commentItem3_1 = [[DFLineCommentItem alloc] init];
//    commentItem3_1.commentId = 78718789;
//    commentItem3_1.userId = 10010;
//    commentItem3_1.userNick = @"狄仁杰";
//    commentItem3_1.text = @"神探是我";
//    [textImageItem3.comments addObject:commentItem3_1];
//
//    [self addItem:textImageItem3];
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
    commentItem.commentId = [NIMBaseUtil GetServerTime]/1000;
    commentItem.userId = OWNERID;
    commentItem.userNick = [card defaultName];
    commentItem.content = text;
    commentItem.createTime = [NIMBaseUtil GetServerTime]/1000;
    commentItem.commentType = Comment_Type_Comment;
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:itemId];
    if (commentId > 0) {
        DFLineCommentItem *replyCommentItem = [[NIMMomentsManager sharedInstance] getCommentItem:commentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
    }
    commentItem.articleId = item.itemId;
    commentItem.articleUserId = item.userId;
    [[NIMMomentsManager sharedInstance] sendMomentsCommentAddRQ:commentItem];

//    [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
}

-(void)onLike:(int64_t)itemId
{
    //点赞
    [[NIMMomentsManager sharedInstance] onLike:itemId];
}

-(void)onClickUser:(NSUInteger)userId
{
    NIMSelfViewController * selfVC = [[NIMSelfViewController alloc]init];
    selfVC.userid = userId;
    selfVC.feedSourceType =ChatSource;
    [selfVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:selfVC animated:YES];
}

-(void)onClickHeaderUserAvatar
{
    //点击左边头像 或者 点击评论和赞的用户昵称
    UserViewController *controller = [[UserViewController alloc] init];
    controller.userid = OWNERID;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)refresh
{
    //下来刷新
    [[NIMMomentsManager sharedInstance] sendMomentsTimelineQueryRQ:OWNERID startTime:0 endTime:[NIMBaseUtil GetServerTime]/1000];
}





-(void) loadMore
{
    //加载更多x
    //模拟网络请求
    static int64_t time = 0;
    NSArray *arr = [[NIMMomentsManager sharedInstance] moment_arr];
    DFBaseLineItem *item = arr.lastObject;
    if (time != item.ts) {
        time = item.ts;
        NSLog(@"开始时间：%f",[[NSDate date] timeIntervalSince1970]);
        [[NIMMomentsManager sharedInstance] sendMomentsTimelineQueryRQ:OWNERID startTime:0 endTime:item.ts-1];
    }else{
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self endRefresh];
    }
//    [self endLoadMore];
//    [self.tableView reloadData];
}

//选择照片后得到数据
-(void)onSendTextImageItem:(DFTextImageLineItem *)item
{
    [[NIMMomentsManager sharedInstance] insertTopArticleItem:item];
    [self.tableView reloadData];
//    [self addItemTop:item];
}

-(void)onSendTextVideoItem:(DFVideoLineItem *)item
{
    [[NIMMomentsManager sharedInstance] insertTopArticleItem:item];
    [self.tableView reloadData];
}

//发送视频 目前没有实现填写文字
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot
{
    /*
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 10000000; //随便设置一个 待服务器生成
    videoItem.userId = 10018;
    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    videoItem.userNick = @"富二代";
    videoItem.title = @"发表了";
    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    videoItem.location = @"广州";
    
    videoItem.localVideoPath = videoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    */
//    [self addItemTop:videoItem];

    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
}



-(void)recvSendArticle:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
            return;
        }else{
            int64_t itemId = [object longLongValue];
            if (_videoItem.itemId == itemId) {
                [[NIMMomentsManager sharedInstance] insertTopArticleItem:_videoItem];
                [self.tableView reloadData];
            }
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:nil];
    }
}

-(void)recvGetArticle:(NSNotification *)noti
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reloadData
{
    [self.tableView reloadData];
}

@end
