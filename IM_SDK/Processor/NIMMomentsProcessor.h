//
//  NIMMomentsProcessor.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/4.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMBaseProcessor.h"
#import "NIMBaseProcessor.h"
#import "DFBaseLineItem.h"

@interface NIMMomentsProcessor : NIMBaseProcessor

-(void)sendMomentsArticleRQ:(DFBaseLineItem *)item;

-(void)deleteMomentsArticleRQ:(DFBaseLineItem *)item;

-(void)sendMomentsTimelineQueryRQ:(int64_t)userid startTime:(int64_t)startTime endTime:(int64_t)endTime;

-(void)sendMomentsCommentAddRQ:(DFLineCommentItem *)commentItem;

-(void)deleteMomentsCommentRQ:(DFLineCommentItem *)commentItem;

-(void)sendQueryMomentsRQ:(int64_t)friendid endTime:(int64_t)endTime;

-(void)settingModifyRQ:(DFSettingItem *)item;
-(void)settingQueryRQ:(int64_t)userid;
-(void)settingBlacknotcarelistModifyRQ:(List_Type)type list:(NSString *)list;

-(void)queryPicArticle:(int64_t)userid;

-(void)sendMomentsIdsQueryRQ:(NSArray *)timelines;

@end
