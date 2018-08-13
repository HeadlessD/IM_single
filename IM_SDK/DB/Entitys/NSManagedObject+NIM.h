//
//  NSManagedObject+NIM.h
//  qbnimclient
//
//  Created by 秦雨 on 17/11/22.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NIM)
+ (NSArray*)NIM_findAllWithPredicate:(NSPredicate*)predicate;
+ (instancetype) NIM_findFirstWithPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) NIM_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (id) NIM_createEntity;
+ (BOOL) NIM_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (NSFetchedResultsController *) NIM_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id)delegate;
+ (NSFetchedResultsController *) NIM_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSUInteger) NIM_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSFetchRequest *) NIM_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
- (BOOL) NIM_deleteEntity;
+ (id) NIM_executeFetchRequest:(NSPredicate *)searchTerm fetchOffset:(NSInteger)offset fetchLimit:(NSInteger)limit;
@end
