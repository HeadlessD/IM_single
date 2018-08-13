//
//  CoraDataManager.h
//  QianbaoIM
//
//  Created by Yun on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMCoreDataManager;

@interface NIMCoreDataManager : NSObject
@property ( strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property ( strong, nonatomic) NSManagedObjectContext *privateObjectContext;
@property ( strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property ( strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property ( strong, nonatomic) NSLock *dataLock;

+ (NIMCoreDataManager*)currentCoreDataManager;
+ (void)clearcurrentCoreDataManager;
- (NSURL *)applicationDocumentsDirectory;
- (NSString *)recordPathCaf;
- (NSString *)recordPathMp3;
- (NSString *)recordPathImg;
- (NSString *)recordPathMov;
- (NSManagedObjectContext *)privateObjectContext;
//回到主线程写数据
- (void)saveDataToDisk;
//清除coredata
- (void)cleanUp;

@end
