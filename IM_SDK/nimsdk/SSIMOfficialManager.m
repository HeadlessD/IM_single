//
//  NIMOfficialMnager.m
//  NIMSDK1
//
//  Created by 秦雨 on 17/5/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMOfficialManager.h"
#import "NIMOffcialInfo.h"
#import "NIMMessageErrorManager.h"

@interface SSIMOfficialManager()

@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,assign)uint64_t offcialid;

@end

@implementation SSIMOfficialManager
SingletonImplementation(SSIMOfficialManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSArray *)fetchOfficialMessage:(uint64_t)officialid offset:(NSInteger)offset limit:(NSInteger)limit
{
    if (officialid<=0 || offset<0 || limit<0) {
        return nil;
    }
    _fetchedResultsController = nil;
    _offcialid = officialid;
    NSInteger totalCount = [self getFethedResultsCount];
    if ((totalCount - offset) < limit) {
        limit = totalCount - offset;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, limit)];
    NSArray *chatArray = [self.fetchedResultsController.fetchedObjects objectsAtIndexes:indexSet];
    return chatArray;
}

-(SSIMMessage *)getMessageByMessageid:(uint64_t)messageid
{
    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:messageid];
    if (chatEntity) {
        SSIMMessage *message = [[NIMMessageErrorManager sharedInstance] transChatEntity:chatEntity];
        return message;
    }else{
        return nil;
    }
}


-(void)addOffcialInfoWithOffcialid:(int64_t)offcialid name:(NSString *)name avatar:(NSString *)avatar
{
    
    NIMOffcialInfo *info = [[NIMOffcialInfo alloc] initWithOffcialid:offcialid name:name avatar:avatar];
    [[NIMOfficialOperationBox sharedInstance] addOffcialInfo:info];
    
}


- (NSInteger)getFethedResultsCount
{
    NSInteger count = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        count = [sectionInfo numberOfObjects];
    }
    return count;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatType = %d AND opUserId = %lld",PUBLIC,_offcialid];
    
    NSFetchRequest *fetchRequest = [ChatEntity NIM_requestAllSortedBy:@"ct" ascending:NO withPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] sectionNameKeyPath:nil cacheName:nil/*[self cacheChatName]*/];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSError *error;
    
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}


@end
