//
//  NSManagedObject+NIM.m
//  qbnimclient
//
//  Created by 秦雨 on 17/11/22.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NSManagedObject+NIM.h"

@implementation NSManagedObject (NIM)

+ (NSManagedObjectContext *)privateObjectContext;
{
    return [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
}

+(NSArray *)NIM_findAllWithPredicate:(NSPredicate *)predicate
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_findAllWithPredicate:predicate inContext:[self privateObjectContext]];
}

+ (instancetype)NIM_findFirstWithPredicate:(NSPredicate *)searchTerm
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_findFirstWithPredicate:searchTerm inContext:[self privateObjectContext]];
}

+ (NSArray *) NIM_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:[self privateObjectContext]];
}

+(id)NIM_createEntity
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_createEntityInContext:[self privateObjectContext]];
}

+(BOOL)NIM_deleteAllMatchingPredicate:(NSPredicate *)predicate
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_deleteAllMatchingPredicate:predicate inContext:[self privateObjectContext]];

}

+(NSFetchedResultsController *)NIM_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id)delegate
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_fetchAllGroupedBy:group withPredicate:searchTerm sortedBy:sortTerm ascending:ascending delegate:delegate inContext:[self privateObjectContext]];
}

+ (NSFetchedResultsController *) NIM_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_fetchAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm groupBy:groupingKeyPath delegate:delegate inContext:[self privateObjectContext]];
}

+ (NSUInteger) NIM_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
{
    if ([self privateObjectContext] == nil) {
        return 0;
    }
    return [self MR_countOfEntitiesWithPredicate:searchFilter inContext:[self privateObjectContext]];
}

+ (NSFetchRequest *) NIM_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
    if ([self privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:[self privateObjectContext]];
}

- (BOOL) NIM_deleteEntity
{
    if ([[NIMCoreDataManager currentCoreDataManager] privateObjectContext] == nil) {
        return nil;
    }
    return [self MR_deleteEntityInContext:[[NIMCoreDataManager currentCoreDataManager] privateObjectContext]];
}

+ (id) NIM_executeFetchRequest:(NSPredicate *)searchTerm fetchOffset:(NSInteger)offset fetchLimit:(NSInteger)limit
{
    NSManagedObjectContext *context = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchOffset:offset];
    [request setFetchLimit:limit];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"ct" ascending:NO];
    [request setSortDescriptors:@[descriptor]];
    NSArray *results = [self MR_executeFetchRequest:request inContext:context];
    return results;
}

@end
