//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineCommentItem.h"
#import "DFLineCommentItem.h"

#import "DFBaseTimeLineViewController.h"

#import "DFImagesSendViewController.h"
#import "DFVideoCaptureController.h"
@interface DFTimeLineViewController : DFBaseTimeLineViewController

//添加到末尾
-(void) addItem:(DFBaseLineItem *) item;

//添加到头部
-(void) addItemTop:(DFBaseLineItem *) item;

//根据ID删除
-(void) deleteItem:(long long) itemId;

//赞
-(void) addLikeItem:(DFLineCommentItem *) likeItem itemId:(long long) itemId;

//评论
-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;


//发送图文
-(void)onSendTextImageItem:(DFTextImageLineItem *)item;

//发送视频消息
-(void)onSendTextVideoItem:(DFVideoLineItem *)item;

@end
