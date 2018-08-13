//
//  CoraDataManager.m
//  QianbaoIM
//
//  Created by Yun on 14/8/27.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMCoreDataManager.h"
#import <CoreData/CoreData.h>

static NIMCoreDataManager* manager;

@interface NIMCoreDataManager ()

@property (nonatomic, strong) dispatch_queue_t coredata_queue_t;


@end

@implementation NIMCoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (NIMCoreDataManager*)currentCoreDataManager
{
    if(!manager)
    {
        manager = [[self alloc] init];
    }
    return manager;
}
+ (void)clearcurrentCoreDataManager
{
    manager = nil;
}

//回到主线程写数据
- (void)saveDataToDisk
{
//    dispatch_async(self.coredata_queue_t, ^{
        [[self privateObjectContext] MR_saveToPersistentStoreAndWait];
//    });
}

- (void)save
{
    [[self privateObjectContext] MR_saveToPersistentStoreAndWait];

}



#pragma mark public
- (NSManagedObjectContext *)privateObjectContext{

    if (_privateObjectContext != nil) {
        return _privateObjectContext;
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[self managedObjectContext]];
    _privateObjectContext = context;
    return context;
}

- (NSURL *)mergedObjectModelFromMainBundle {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.qianbao.QianbaoIM" in the application's documents directory.
    NSString *surl = [[NSBundle mainBundle] sharedFrameworksPath];
    NSString *path = [NSString stringWithFormat:@"%@/%llu/",surl,OWNERID];
    //DBLog(@"data base localtion %@",path);
//    if(OWNERID == 0){
//        return nil;
//    }
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isDir=YES;
    BOOL existed=[fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDir==YES&&existed==YES))
    {
        NSError* error = nil;
        BOOL result= [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:path] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            DBLog(@"%@",error);
        }
    }
    //    [NIMCurrentUserInfo currentInfo].currentUserFolder = path;
    //    [[NIMCurrentUserInfo currentInfo] writeUserInfoToDisk];
    return [NSURL fileURLWithPath:path];
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.qianbao.QianbaoIM" in the application's documents directory.
    NSString *surl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/%llu/",surl,OWNERID];
    //DBLog(@"data base localtion %@",path);
//    if(OWNERID == 0){
//        return nil;
//    }
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isDir=YES;
    BOOL existed=[fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDir==YES&&existed==YES))
    {
        NSError* error = nil;
        BOOL result= [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:path] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
           DBLog(@"%@",error);
        }
    }
//    [NIMCurrentUserInfo currentInfo].currentUserFolder = path;
//    [[NIMCurrentUserInfo currentInfo] writeUserInfoToDisk];
    return [NSURL fileURLWithPath:path];
}

- (NSString *)recordPathCaf{
    NSString *recordPath = nil;
    NSString *applicationDocumentsDirectoryPath = [self.applicationDocumentsDirectory path];
    recordPath = [applicationDocumentsDirectoryPath stringByAppendingPathComponent:@"record/caf"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isDir=YES;
    BOOL existed=[fileManager fileExistsAtPath:recordPath isDirectory:&isDir];
    if(!(isDir==YES&&existed==YES))
    {
        NSError* error = nil;
        BOOL result= [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:recordPath] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            DBLog(@"%@",error);
        }
    }

    return recordPath;
}
- (NSString *)recordPathMp3{
    NSString *recordPath = nil;
    NSString *applicationDocumentsDirectoryPath = [self.applicationDocumentsDirectory path];
    recordPath = [applicationDocumentsDirectoryPath stringByAppendingPathComponent:@"record/mp3"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isDir=YES;
    BOOL existed=[fileManager fileExistsAtPath:recordPath isDirectory:&isDir];
    if(!(isDir==YES&&existed==YES))
    {
        NSError* error = nil;
        BOOL result= [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:recordPath] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            DBLog(@"%@",error);
        }
    }
    
    return recordPath;
}


- (NSString *)recordPathImg{
    NSString *imageDirectory = [[self.applicationDocumentsDirectory path] stringByAppendingPathComponent:@"record/image/CHAT_IMAGE"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageDirectory;
}


- (NSString *)recordPathMov{
    NSString *recordPath = nil;
    NSString *applicationDocumentsDirectoryPath = [self.applicationDocumentsDirectory path];
    recordPath = [applicationDocumentsDirectoryPath stringByAppendingPathComponent:@"record/mov"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isDir=YES;
    BOOL existed=[fileManager fileExistsAtPath:recordPath isDirectory:&isDir];
    if(!(isDir==YES&&existed==YES))
    {
        NSError* error = nil;
        BOOL result= [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:recordPath] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            DBLog(@"%@",error);
        }
    }
    return recordPath;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"QBNIMSDK" ofType:@"framework"];
//    
//    
//    NSString *path1 = [NSString stringWithFormat:@"%@/qianbaoIM.momd",path];
//    NSURL *modelURL = [NSURL fileURLWithPath:path1];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SSIMCoreData" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    [NSManagedObjectModel MR_setDefaultManagedObjectModel:_managedObjectModel];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    [self.dataLock lock];
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SSIMCoreData.sqlite"];
    DBLog(@"storeURL:%@",storeURL);
    if(!storeURL){
        return nil;
    }
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
//    [NIMCurrentUserInfo currentInfo].coreDataIsOk = YES;
//    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:_persistentStoreCoordinator];
    [self.dataLock unlock];
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
//    [NSManagedObjectContext MR_defaultContext]
    return _managedObjectContext;
}

-(NSLock *)dataLock
{
    if (!_dataLock) {
        _dataLock = [[NSLock alloc] init];
    }
    return _dataLock;
}

-(void)cleanUp
{
    _privateObjectContext = nil;
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _dataLock = nil;
}

- (dispatch_queue_t)coredata_queue_t{
    if (_coredata_queue_t == nil) {
        _coredata_queue_t = dispatch_queue_create("com.nim.coredataQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return _coredata_queue_t;
}


@end
