//
//  NIMSubTimeTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubTimeTableViewCell.h"

//#import "PublicEntity.h"
#import "GMember+CoreDataClass.h"
#import "UIlabel+NIMAttributed.h"

@interface NIMSubTimeTableViewCell()
{
    UIImageView* img;
    BOOL isAnimating;
}

@property (nonatomic, copy) NSString* lastThread;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic, strong) ChatListEntity *chatList;
@end

@implementation NIMSubTimeTableViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}




- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [(UITapGestureRecognizer*)gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (5 < translation.x && translation.x < 50 && translation.y >5 && translation.y < 65)
    {
        return NO;
    }
    
    return YES;
}


#pragma mark 新改
- (void)updateWithGroupThread:(NSString *)thread group:(GroupList *)groupEntity{
    NSString *idStr = @"";
    if (groupEntity == nil) {
        
        int64_t groupid = [NIMStringComponents getOpuseridWithMsgBodyId:thread];
        
        [[NIMGroupOperationBox sharedInstance] sendBatchGroupInfoRQ:@[@(groupid)]];
    }else{
        idStr = [NSString stringWithFormat:@"%lld",groupEntity.groupId];
    }
    
    self.titleLable.text = IsStrEmpty(groupEntity.name)?idStr:groupEntity.name;

    [self.iconView setViewDataSourceFromUrlString:GROUP_ICON_URL([NIMStringComponents getOpuseridWithMsgBodyId:thread])];
    
}

//修改群成员
-(void)groupPreview:(ChatListEntity*)recordList
{
    ChatEntity* recordEntity = nil;
    NSArray* all = [[NIMMessageManager sharedInstance] getMessagesBySessionId:recordList.messageBodyId];
    if(all.count>0)
    {
        NSDictionary *dict = [all lastObject];
        recordEntity = dict.allValues.firstObject;

    }
    if (recordEntity == nil) {
        return ;
    }
    NSMutableString *preview = [[NSMutableString alloc] init];
    
    if (recordEntity.opUserId != OWNERID &&
        recordEntity.stype != TIP) {
        GroupList *groupEntity = [[GroupManager sharedInstance] GetGroupList:recordList.messageBodyId];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(messageBodyId = %@) AND (userid = %@)",groupEntity.messageBodyId,@(recordEntity.opUserId)];
        GMember *member = [GMember NIM_findFirstWithPredicate:predicate1];
        if (!member) {
            member = [GMember NIM_createEntity];
            member.messageBodyId = recordList.messageBodyId;
            member.userid = recordEntity.opUserId;
        }
        member.groupmembernickname = recordEntity.sendUserName;
        
        VcardEntity *card = member.vcard;
        if (nil == card){
            card = [VcardEntity instancetypeFindUserid:member.userid];
        }
        FDListEntity * fdList = [[GroupManager sharedInstance] GetFDList:member.userid];
        NSString *name =nil;
        
        if (fdList && !IsStrEmpty(fdList.fdRemarkName)) {
            name = fdList.fdRemarkName;
        }else{
            if (member) {
                name = [member groupmembernickname];
            }else{
                name = [card defaultName];
            }
        }
        
        if (name.length>12) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:12]];
        }
        if (!IsStrEmpty(name)) {
            [preview appendFormat:@"%@:",name];
        }

    }
    
    [preview appendFormat:@"%@",recordList.preview];
    
    [self.introLablel setText:preview];
}

- (void)updateWithGroupNotifyMsg:(NSString *)msg withTimestamp:(NSTimeInterval)timestamp
{
    //小喇叭
    [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_groupchat")];
    if (msg.length > 0 )
    {
        self.titleLable.text = @"群通知";
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_top).with.offset(-5);
            make.leading.equalTo(self.iconView.mas_trailing).with.offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
            make.height.equalTo(@20);
        }];
        
        [self.introLablel setText:msg];
        
        [self.timeLablel setText:[SSIMSpUtil chatListParseTime:timestamp]];
    }
    else
    {
        self.titleLable.text = @"群通知";
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.leading.equalTo(self.iconView.mas_trailing).with.offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
            make.height.equalTo(@20);
        }];
        
        [self.introLablel setText:@""];
    }
    
    [self configUnreadCount:0];
}

#pragma mark public
- (void)updateWithRecordList:(ChatListEntity*)recordList isRedAnimating:(BOOL)isRedAnimating
{
    if (recordList.topAlign) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:0.4];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    self.chatList = recordList;
    isAnimating = isRedAnimating;
    
    self.badgeView.userInteractionEnabled = NO;//因为临时需求小红点拖拽功能取消
    
    //聊天消息需要显示发送失败
    if (recordList.chatType == GROUP || recordList.chatType == PUBLIC || recordList.chatType == PRIVATE) {
        
        ChatEntity* recordEntity = nil;
        
        NSArray * all = [[NIMMessageManager sharedInstance] getMessagesBySessionId:recordList.messageBodyId];
        if(all.count!=0){
            NSDictionary *dict = [all lastObject];
            recordEntity = dict.allValues.firstObject;
            if (recordEntity == nil) {
                return ;
            }
            if (recordEntity.status == QIMMessageStatuUpLoadFailed) {
                [self failMakeConstraints];
            }else{
                [self successMakeConstraints];
            }
            
        }else{
            [self successMakeConstraints];
        }
    }
    
    [self.introLablel setText:recordList.preview];
    [self.timeLablel setText:[SSIMSpUtil chatListParseTime:recordList.ct/1000]];
    self.noticeImgView.image = IMGGET(@"nim_icon_notify");
    self.noticeImgView.hidden = YES;
    /*
     INVALID      = -1,
     SYS          = 1,           // 系统消息
     GROUP        = 2,
     PUBLIC       = 3,
     PRIVATE      = 4,
     */
    
    int64_t session_id = [NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId];
    int unread_count = [[NIMMsgCountManager sharedInstance] GetUnreadCount:session_id chat_type:recordList.chatType];
    switch (recordList.chatType) {
            
        case SYS:{// 系统消息
            [self successMakeConstraints];
            if ([recordList.messageBodyId isEqualToString:kTaskHelperThread]){
                [self configUnreadCount:unread_count];
                [self configUnreadCount1:unread_count isPublic:/*recordList.isPublic*/unread_count>0 andCount:unread_count];
                NSString *name = @"任务助手";
                self.titleLable.text = name;
                [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_assistant")];
                return;
            }else if ([recordList.messageBodyId isEqualToString:kSubscribeThread]){
                [self configUnreadCount1:unread_count>0 isPublic:/*recordList.isPublic*/unread_count>0 andCount:unread_count];
                NSString *name = @"订阅助手";
                self.titleLable.text = name;
                [self.iconView setViewIconFromImage:IMGGET(@"nim_icon_subscribe")];
                
                return;
            }else if ([recordList.messageBodyId isEqualToString:kNewFriendThread]){
                [self successMakeConstraints];
                self.titleLable.text = @"新的朋友";
                [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_addfriend")];
                [self configUnreadCount:unread_count];
                
                return;
            }else if ([recordList.messageBodyId isEqualToString:kPublicPacketThread]){
                [self configUnreadCount1:recordList.showRedPublic isPublic:recordList.isPublic andCount:unread_count];
                NSString *name = @"公众号消息";
                self.titleLable.text = name;
                [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_gongzhonghao")];
                //                PublicEntity *publicEntity = [PublicEntity getFirstEntityWithSearchKeys:[NSPredicate predicateWithFormat:@"messageBodyId=%@",recordList.actualThread]];
                //                NSString *publicName = publicEntity.name;
                //                if (!IsStrEmpty(publicName)) {
                //                    NSString *str = [NSString stringWithFormat:@"%@:%@",publicName,recordList.preview];
                //                    [self.introLablel setText:str];
                //                }
                return;
            }else if ([recordList.messageBodyId isEqualToString:kGroupAssistantThread]){
                NSString *name = @"群助手";
                self.titleLable.text = name;
                
                
                self.introLablel.text = recordList.preview;
                
                if (recordList.preview.length > 0) {
                    if (([recordList.preview hasPrefix:@"["] && recordList.groupAssistantRead)
                        || [recordList.preview isEqualToString:@"[您有新的群通知]"]) {
                        NSDictionary *attributeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                        NSForegroundColorAttributeName:UIColorOfHex(0xff7a22)};
                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:recordList.preview?recordList.preview:@"" attributes:attributeDict];
                        
                        self.introLablel.attributedText = AttributedStr;
                    }
                }
                
                [self.iconView setViewIconFromImage:IMGGET(@"icon_qunzhushou")];
                
                //群组手不显示小红点数字了
                [self configUnreadCount1:/*unread_count>0*/NO isPublic:recordList.isPublic andCount:unread_count];
                return;
            }else if ([recordList.messageBodyId isEqualToString:kShopThread]){
                [self successMakeConstraints];
                self.titleLable.text = @"店铺消息";
                [self.iconView setViewIconFromImage:IMGGET(@"shop_chat_icon")];
                
                //查找是否有店铺消息
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"(chatType = %d || chatType = %d) AND userId = %lld",SHOP_BUSINESS,CERTIFY_BUSINESS,OWNERID];
                
                NSArray * businessArr = [ChatListEntity NIM_findAllWithPredicate:pre];
                
                if (businessArr.count == 0) {//没有店铺消息
                    self.introLablel.text = @"暂无商家消息";
                }
                else
                {//有店铺消息
                    NSArray * unreadArr = [ChatListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"shopAssistantRead > 0 and userId == %lld",OWNERID]];
                    
                    //判断是否有未读的商家消息
                    if (unreadArr.count) {//有未读消息
                        NSDictionary *attributeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                        NSForegroundColorAttributeName:UIColorOfHex(0xff7a22)};
                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%ld个店铺有新消息]",unreadArr.count]  attributes:attributeDict];
                        
                        self.introLablel.attributedText = AttributedStr;
                    }
                    else
                    {
                        //没有未读的消息，显示最后一条 找到最后一条商家消息
                        NSPredicate *lastPre = [NSPredicate predicateWithFormat:@"(chatType = %d || chatType = %d) AND userId = %lld",SHOP_BUSINESS,CERTIFY_BUSINESS,OWNERID];
                        NSArray * msgArr = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:lastPre];
                        
                        ChatEntity * lastMsg = msgArr[0];
                        
                        //判断发送方是不是自己，自己不用显示商家名称
                        if (lastMsg.isSender != 1) {
                            
                            NSArray *arr = [lastMsg.messageBodyId componentsSeparatedByString:@":"];
                            
                            NSString * buinessName = [arr objectAtIndex:2];
                            if (lastMsg.chatType == SHOP_BUSINESS) {
                                self.introLablel.text = [NSString stringWithFormat:@"商家·%@：%@",buinessName,recordList.preview];
                            }else if (lastMsg.chatType == CERTIFY_BUSINESS){
                                self.introLablel.text = [NSString stringWithFormat:@"企业商家·%@：%@",buinessName,recordList.preview];
                            }
//                                                        self.introLablel.text = [NSString stringWithFormat:@"商家%lld：%@",lastMsg.opUserId,lastMsg.msgContent];
                        }else{
                            self.introLablel.text = recordList.preview;
                        }
                    }
                    [self configUnreadCount1:unreadArr.count isPublic:YES andCount:unread_count];
                }
                return;
            }
            
            break;
        }
            
        case GROUP:{// 群组消息
            
            GroupList *groupList = [[GroupManager sharedInstance] GetGroupList:recordList.messageBodyId];

            [self groupPreview:recordList];
            [self updateWithGroupThread:recordList.messageBodyId group:groupList];
            

            BOOL isPublic = recordList.isPublic || groupList.switchnotify == GROUP_MESSAGE_STATUS_NO_HIT;
            
            
            if (groupList.switchnotify == 1) {
                _noticeImgView.hidden = NO;
            }else{
                _noticeImgView.hidden = YES;
            }
            
            
            [self configUnreadCount1:unread_count>0 isPublic:isPublic andCount:unread_count];
            
            break;
        }
            
        case PUBLIC:{// 公众号消息
            NSString *sysMbd = [NIMStringComponents createMsgBodyIdWithType:PUBLIC toId:kSystemID];
            if ([recordList.messageBodyId isEqualToString:sysMbd]){
                NSString *name = @"系统消息";
                self.titleLable.text = name;
                
                
                self.introLablel.text = recordList.preview;
                
                [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_circular")];
                
                //群组手不显示小红点数字了
                [self configUnreadCount1:unread_count>0 isPublic:recordList.isPublic andCount:unread_count];
                return;
            }
            
            
            NOffcialEntity *offcialEntity = [NOffcialEntity findFirstWithMsgBodyId:recordList.messageBodyId];
            if (offcialEntity) {
                self.titleLable.text = offcialEntity.name;
                [self.iconView setViewDataSourceFromUrlString:offcialEntity.avatar];
            }
            
            if (recordList.isflod){//折叠公众号
                [self configUnreadCount1:recordList.showRedPublic isPublic:unread_count>0 andCount:unread_count];
            }else{
                if (recordList.isPublic)
                {
                    NSString *str = recordList.preview;
                    [self configUnreadCount1:recordList.showRedPublic isPublic:recordList.isPublic andCount:unread_count];
                    NSString *name = @"公众号消息";
                    self.titleLable.text = name;
                    [self.iconView setViewIconFromImage:IMGGET(@"icon_qb_gongzhonghao")];
                    NOffcialEntity *publicEntity = [NOffcialEntity findFirstWithMsgBodyId:recordList.messageBodyId];
                    NSString *publicName = publicEntity.name;
                    if (!IsStrEmpty(publicName))
                    {
                        str = [NSString stringWithFormat:@"%@:%@",publicName,recordList.preview];
                        [self.introLablel setText:str];
                    }
                }else{
                    //非折叠公众号
                    [self configUnreadCount1:unread_count>0 isPublic:recordList.isPublic andCount:unread_count];
                }
                
                
            }
            break;
        }
            
        case PRIVATE:{// 私信
//            NSArray *arr = [recordList.messageBodyId componentsSeparatedByString:@":"];
//            E_MSG_CHAT_TYPE type = [NIMStringComponents chatTypeWithMsgBodyId:recordList.actualThread];
            int64_t friendid = [NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId];
            FDListEntity *fdList = [[GroupManager sharedInstance] GetFDList:friendid];
            
            BOOL isPublic = recordList.isPublic || fdList.apnswitch == GROUP_MESSAGE_STATUS_NO_HIT;
            
            [self configUnreadCount1:unread_count>0 isPublic:isPublic andCount:unread_count];
            
            VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:friendid];
            
            [self.iconView setViewDataSourceFromUrlString:USER_ICON_URL(friendid)];
            
            self.titleLable.text = [NIMStringComponents finFristNameWithID:friendid];

            if (fdList.apnswitch) {
                _noticeImgView.hidden = NO;
            }else{
                _noticeImgView.hidden = YES;
            }
            
            break;
        }
            
        case SHOP_BUSINESS:
        case CERTIFY_BUSINESS:
        {
            NSArray *arr = [recordList.messageBodyId componentsSeparatedByString:@":"];
            NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:[arr.lastObject longLongValue]];
            [self configUnreadCount1:unread_count>0 isPublic:NO andCount:unread_count];
            
            if (business) {
                self.titleLable.text = business.name;
            }else{
                if (recordList.chatType == SHOP_BUSINESS) {
                    self.titleLable.text = [NSString stringWithFormat:@"商家_%@",[arr objectAtIndex:2]];
                }else if (recordList.chatType == CERTIFY_BUSINESS){
                    self.titleLable.text = [NSString stringWithFormat:@"企业商家_%@",[arr objectAtIndex:2]];
                }
            }
            
            if (IsStrEmpty(business.avatar)) {
                [self.iconView setViewIconFromImage:[UIImage imageNamed:@"fclogo"]];
            }else{
                [self.iconView setViewDataSourceFromUrlString:business.avatar];
            }
            
            [self.introLablel setText:recordList.preview];
            
            
            
            
            
            
            
            [self.timeLablel setText:[SSIMSpUtil chatListParseTime:recordList.ct/1000]];
            break;
        }
            
            
        default:
            break;
    }
    
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    
    
    if(self.isBlue)
    {
        self.badgeLabel.layer.backgroundColor = [SSIMSpUtil getColor:@"96D7F0"].CGColor;
        img.hidden = YES;
    }
    else
    {
        self.badgeLabel.layer.backgroundColor = _COLOR_RED.CGColor;
        img.hidden = NO;
    }

}

- (void)configUnreadCount:(NSInteger)count
{
    [_badgeView setHidden:YES];
    [_badgeLabel setHidden:NO];
    if(count == 0)
    {
        _badgeLabel.hidden = YES;
        return;
    }
    NSString *badgeString = _BADGESTR(count);
    _badgeLabel.text = badgeString;
    
}

- (void)configUnreadCount1:(BOOL)showRed isPublic:(BOOL)isPublic andCount:(NSInteger)count
{
    if (showRed)
    {
        
        if (isPublic)
        {
            [self.badgeView setHidden:NO];
            [self.badgeLabel setHidden:YES];
        }
        else
        {
            [self.badgeView setHidden:YES];
            [self.badgeLabel setHidden:NO];
            [self configUnreadCount:count];
        }
    }
    else
    {
        if (isAnimating) {
            [self redAnimating];
        }
        else
        {
            _badgeView.hidden = YES;
            _badgeLabel.hidden = YES;
        }
    }
}

- (double)otherUidWithThread:(NSString *)thread{
    NSArray *nums = [thread componentsSeparatedByString:@":"];
    
    E_MSG_CHAT_TYPE packetType = [[nums firstObject] integerValue];
    
    if(nums.count == 3){//不是和店小二聊天
        if (packetType == GROUP) {
            packetType = [[nums objectAtIndex:1] doubleValue];
        }else if(packetType == PRIVATE){
            double mid = [[nums objectAtIndex:1] doubleValue];
            double lastid = [[nums objectAtIndex:2] doubleValue];
            if (mid != OWNERID) {
                return mid;
            }else{
                return lastid;
            }
        }
        
    }
    else if( nums.count == 4 )//和店小二之间聊天
    {
        /*
         double firstID = [[nums objectAtIndex:1] doubleValue];
         double secondID = [[nums objectAtIndex:2] doubleValue];
         double thirdID = [[nums objectAtIndex:3] doubleValue];
         if(packetType == E_MSG_CHAT_TYPEPrivate){
         
         ChatListEntity*recordList=[ChatListEntity instancetypeWithThread:thread];
         if (recordList.userId.integerValue==OWNERID) {//我是店小二
         return secondID;
         }else{
         if (thirdID==OWNERID) {
         return secondID;
         }
         return thirdID;
         }
         }else if(packetType == E_MSG_CHAT_TYPEPublic)
         {
         return thirdID;
         }
         */
    }
    
    
    
    
    
    
    return 0;
}

#pragma mark config
- (void)makeConstraints{
    
    [super makeConstraints];
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(-5);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
        make.height.equalTo(@20);
        
    }];
    
    [self.timeLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_top).with.offset(0);
        make.leading.equalTo(self.titleLable.mas_trailing);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.titleLable.mas_bottom);
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
    
    [self.noticeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.timeLablel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-12);
        make.trailing.equalTo(self.timeLablel.mas_trailing).with.offset(-7);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    [self.badgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.iconView.mas_top).with.offset(-5);
        //        make.trailing.equalTo(self.iconView.mas_trailing).with.offset(10);
        //        make.width.greaterThanOrEqualTo(@20);
        //        make.height.equalTo(@20);
        
        make.centerX.equalTo(self.iconView.mas_trailing);
        make.centerY.equalTo(self.iconView.mas_top);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self.badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconView.mas_trailing);
        make.centerY.equalTo(self.iconView.mas_top);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    
    [self successMakeConstraints];
    
}
//消息发送失败显示
- (void)failMakeConstraints{
    [self.infoImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLable.mas_leading);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self.introLablel.mas_centerY);
    }];
    
    [self.introLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(0);
        make.leading.equalTo(self.infoImg.mas_trailing);
        make.trailing.equalTo(self.noticeImgView.mas_leading);
        make.bottom.equalTo(self.iconView.mas_bottom).offset(10);
    }];
}
//消息发送成功显示
- (void)successMakeConstraints{
    [self.infoImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLable.mas_leading);
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.centerY.equalTo(self.introLablel.mas_centerY);
    }];
    [self.introLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(0);
        make.leading.equalTo(self.titleLable.mas_leading);
        make.trailing.equalTo(self.noticeImgView.mas_leading);
        make.bottom.equalTo(self.iconView.mas_bottom).offset(10);
    }];
}
#pragma mark getter
- (UILabel *)timeLablel{
    if (!_timeLablel) {
        _timeLablel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLablel.numberOfLines = 1;
        _timeLablel.font = [UIFont systemFontOfSize:12];
        _timeLablel.textColor = __COLOR_BBBBBB__;
        _timeLablel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLablel];
    }
    return _timeLablel;
}

-(UIImageView *)noticeImgView{
    if (!_noticeImgView) {
        _noticeImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _noticeImgView.contentMode = UIViewContentModeScaleAspectFit;
        //        _noticeImgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_noticeImgView];
    }
    return _noticeImgView;
}


- (UIImageView *)badgeView
{
    if (!_badgeView)
    {
        _badgeView = [[UIImageView alloc] init];
        _badgeView.backgroundColor = [UIColor clearColor];
        //        _badgeView.contentMode = UIViewContentModeScaleAspectFill;
        
        _badgeView.image = IMGGET(@"05");
        _badgeView.frame = CGRectMake(0, 0, 10, 10);
        [self.contentView addSubview:_badgeView];
    }
    return _badgeView;
}

-(void)redAnimating {
    
    /*
     NSMutableArray  *arrayM=[NSMutableArray array];
     for (int i=1; i<9; i++) {
     [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png",i]]];
     }
     //设置动画数组
     [img setAnimationImages:arrayM];
     //设置动画播放次数
     [img setAnimationRepeatCount:1];
     //设置动画播放时间
     [img setAnimationDuration:0.25];
     //开始动画
     [img startAnimating];
     */
    
    
    // 牛：解决小红点多次以后不动画的原因
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        _badgeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
        _badgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.14 animations:^{
            _badgeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001f, 0.001f);
            _badgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001f, 0.001f);
        } completion:^(BOOL finished) {
            if (finished) {
                [_badgeLabel setHidden:YES];
                [_badgeView setHidden:YES];
                [_badgeView setTransform:CGAffineTransformIdentity];
                [_badgeLabel setTransform:CGAffineTransformIdentity];
            }
        }];
    }];
}

- (void)redPointRemoved
{
    
}

- (void)disAppearRedPointWtihCompletion:(void (^)(BOOL))completion
{
    [_badgeLabel setText:@""];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        _badgeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
        //        _badgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.14 animations:^{
            _badgeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001f, 0.001f);
            //            _badgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001f, 0.001f);
        } completion:^(BOOL finished) {
            if (finished) {
                if (completion) {
                    completion(finished);
                }
                [_badgeLabel setHidden:YES];
                //                [_badgeView setHidden:YES];
                //                [_badgeView setTransform:CGAffineTransformIdentity];
                [_badgeLabel setTransform:CGAffineTransformIdentity];
            }
        }];
    }];
}

- (UILabel *)badgeLabel
{
    if(!_badgeLabel)
    {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = [UIColor clearColor];//_COLOR_RED;
        _badgeLabel.layer.backgroundColor = _COLOR_RED.CGColor;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.layer.cornerRadius = 10;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_badgeLabel];
    }
    return _badgeLabel;
}
@end
