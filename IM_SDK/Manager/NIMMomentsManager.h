//
//  NIMMomentsManager.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/4.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBaseLineItem.h"
#import "DFTextImageLineItem.h"
#import "DFTextImageLineItem.h"

typedef void (^ImagesBlock)(id images);


@interface NIMMomentsManager : NSObject

@property (nonatomic,strong) NSMutableDictionary *moment_dict;
@property (nonatomic,strong) NSMutableArray *moment_arr;
@property (nonatomic,strong) NSMutableDictionary *comment_dict;
@property (nonatomic,strong) NSMutableDictionary *user_dict;
@property (nonatomic,strong) NSMutableArray *user_arr;

@property (nonatomic,strong) DFSettingItem *setItem;
@property (nonatomic,assign) BOOL isDetail;

SingletonInterface(NIMMomentsManager)

-(void)sendMomentsArticleRQ:(DFBaseLineItem *)item;
-(void)deleteMomentsArticleRQ:(DFBaseLineItem *)item;
-(void)sendMomentsTimelineQueryRQ:(int64_t)userid startTime:(int64_t)startTime endTime:(int64_t)endTime;

-(void)sendMomentsCommentAddRQ:(DFLineCommentItem *)commentItem;
-(void)deleteMomentsCommentRQ:(DFLineCommentItem *)commentItem;
//查看好友朋友圈
-(void)sendQueryMomentsRQ:(int64_t)friendid endTime:(int64_t)endTime;

-(void)settingModifyRQ:(DFSettingItem *)item;

-(void)settingQueryRQ:(int64_t)userid;

-(void)settingBlacknotcarelistModifyRQ:(List_Type)type list:(NSString *)list;

-(void)queryPicArticle:(int64_t)userid;

-(void)sendMomentsIdsQueryRQ:(NSArray *)timelines;


//拉取
-(void)insertBottomArticleItem:(DFBaseLineItem *)item;
//发朋友圈
-(void)insertTopArticleItem:(DFBaseLineItem *)item;
-(void)deleteItem:(int64_t)itemId;
-(DFBaseLineItem *)getItem:(int64_t) itemId;
-(NSArray *)loadMomentData;
-(void)clear;

-(void)insertLikeItem:(DFLineCommentItem *)item;
-(void)deleteLikeItem:(int64_t)userid;
-(DFLineCommentItem *)getLikeItem:(int64_t)userid;

-(void)insertCommentItem:(DFLineCommentItem *)item;
-(void)deleteCommentItem:(int64_t)commentId;
-(DFLineCommentItem *)getCommentItem:(int64_t) itemId;

-(void)deleteUserItem:(int64_t)itemId;

-(DFTextImageLineItem *)createTextImage:(NSString *)text images:(NSArray *)images;
-(DFLineCommentItem *)createCommentItem:(int64_t)itemId;
-(DFVideoLineItem *)createVideoItem:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot;

-(void) genLikeAttrString:(DFBaseLineItem *) item;
-(void) genCommentAttrString:(DFBaseLineItem *)item;

-(void)insertUserItem:(DFBaseUserLineItem *)item;

-(void)loadMomentDataWithUserId:(int64_t)userId offset:(NSInteger)offset;

-(void)deleteMomentsInNotCare:(NSString *)listStr;

-(void)onLike:(int64_t)itemId;
@end
