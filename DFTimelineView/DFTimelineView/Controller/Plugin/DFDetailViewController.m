//
//  DFDetailViewController.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/3/11.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "DFDetailViewController.h"
#import "DFBaseLineCell.h"
#import "DFLineCellManager.h"
#import "UserViewController.h"
#import "CommentInputView.h"
@interface DFDetailViewController ()<DFLineCellDelegate,CommentInputViewDelegate>
@property (strong, nonatomic) CommentInputView *commentInputView;
@property (strong, nonatomic) DFBaseLineItem *item;
@end

@implementation DFDetailViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeleteArticle:) name:NC_DELETE_ARTICLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSendComment:) name:NC_SEND_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeleteComment:) name:NC_DELETE_COMMENT_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGetArticle:) name:NC_GET_DETAIL object:nil];
    _item = [[NIMMomentsManager sharedInstance] getItem:_itemId];
    if (_item) {
        
    }else{
        [NIMMomentsManager sharedInstance].isDetail = YES;
        DFModel *model = [DFModel new];
        model.articleId = _itemId;
        model.user_id = _userId;
        [[NIMMomentsManager sharedInstance] sendMomentsIdsQueryRQ:@[model]];
    }
    
    [self initCommentInputView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_commentInputView addNotify];
    
    [_commentInputView addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_commentInputView removeNotify];
    
    [_commentInputView removeObserver];
}


-(void) initCommentInputView
{
    if (_commentInputView == nil) {
        _commentInputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _commentInputView.hidden = YES;
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_item) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseLineCell *typeCell = [self getCell:[_item class]];
    return [typeCell getReuseableCellHeight:_item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DFBaseLineCell *typeCell = [self getCell:[_item class]];
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    [cell updateWithItem:_item forRow:indexPath.row];
    return cell;
}


-(DFBaseLineCell *) getCell:(Class)itemClass
{
    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}

-(void)qb_back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) onLike:(int64_t) itemId
{
    [[NIMMomentsManager sharedInstance] onLike:itemId];
}

-(void) onComment:(long long) itemId
{
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
}

-(void) onClickUser:(NSUInteger) userId
{
    //点击左边头像 或者 点击评论和赞的用户昵称
    UserViewController *controller = [[UserViewController alloc] init];
    controller.userid = userId;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) onClickComment:(long long) commentId itemId:(long long) itemId
{
    DFLineCommentItem *comment = [[NIMMomentsManager sharedInstance] getCommentItem:commentId];
    if (comment.userId == OWNERID) {
        return;
    }
//    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    [_commentInputView show];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
}

-(void) onClickDelete:(int64_t) itemId
{
    UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该朋友圈" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_item) {
            [[NIMMomentsManager sharedInstance] deleteMomentsArticleRQ:_item];
        }
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [netAlert addAction:cancle];
    [netAlert addAction:nAction];
    [self presentViewController:netAlert animated:YES completion:^{
    }];
}

-(void) onDeleteComment:(int64_t) itemId
{
    DFLineCommentItem *item = [[NIMMomentsManager sharedInstance] getCommentItem:itemId];
    if (item) {
        [[NIMMomentsManager sharedInstance] deleteMomentsCommentRQ:item];
    }
}




-(void)onCommentCreate:(long long)commentId text:(NSString *)text
{
    VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
    DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
    commentItem.commentId = [NIMBaseUtil GetServerTime]/1000;
    commentItem.userId = OWNERID;
    commentItem.userNick = [card defaultName];
    commentItem.content = text;
    commentItem.createTime = [NIMBaseUtil GetServerTime]/1000;
    commentItem.commentType = Comment_Type_Comment;
    DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:_itemId];
    if (commentId > 0) {
        DFLineCommentItem *replyCommentItem = [[NIMMomentsManager sharedInstance] getCommentItem:commentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
    }
    commentItem.articleId = item.itemId;
    commentItem.articleUserId = item.userId;
    [[NIMMomentsManager sharedInstance] sendMomentsCommentAddRQ:commentItem];
}

-(void)recvDeleteArticle:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            int64_t itemId = [object longLongValue];
            [[NIMMomentsManager sharedInstance] deleteItem:itemId];
            [[NIMMomentsManager sharedInstance] deleteUserItem:itemId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}

-(void)recvSendComment:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            DFLineCommentItem *commentItem = object;
//            DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:commentItem.articleId];
            [[NIMMomentsManager sharedInstance] insertCommentItem:commentItem];
            if (commentItem.commentType == Comment_Type_Like) {
                [[NIMMomentsManager sharedInstance] insertLikeItem:commentItem];
                if (![_item.likes containsObject:commentItem]) {
                    [_item.likes insertObject:commentItem atIndex:0];
                }
                _item.likesStr = nil;
                _item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genLikeAttrString:_item];
            }else if (commentItem.commentType == Comment_Type_Comment){
                if (![_item.comments containsObject:commentItem]) {
                    [_item.comments addObject:commentItem];
                }
                _item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genCommentAttrString:_item];
            }
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}

-(void)recvDeleteComment:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            DFLineCommentItem *commentItem = [[NIMMomentsManager sharedInstance] getCommentItem:[object longLongValue]];
//            DFBaseLineItem *item = [[NIMMomentsManager sharedInstance] getItem:commentItem.articleId];
            if (commentItem.commentType == Comment_Type_Like) {
                [[NIMMomentsManager sharedInstance] deleteLikeItem:commentItem.userId];
                [_item.likes removeObject:commentItem];
                _item.likesStr = nil;
                _item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genLikeAttrString:_item];
            }else if (commentItem.commentType == Comment_Type_Comment){
                [_item.comments removeObject:commentItem];
                _item.cellHeight = 0;
                [[NIMMomentsManager sharedInstance] genCommentAttrString:_item];
            }
            [[NIMMomentsManager sharedInstance] deleteCommentItem:commentItem.commentId];
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
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
            _item = object;
            [self.tableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:self.view];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
