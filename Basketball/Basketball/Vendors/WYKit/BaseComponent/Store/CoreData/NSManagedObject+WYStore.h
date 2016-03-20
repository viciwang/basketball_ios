//
//  NSManagedObject+WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/6.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



typedef void(^WYStoreManagedObjectOperationCompletionBlock)(id object,BOOL success,NSError *error);

@interface NSManagedObject(WYStore)

+ (NSString *)wy_entityName;

+ (instancetype)wy_createManagedObjectInContext:(NSManagedObjectContext *)context;
+ (instancetype)wy_copyManagedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context;

+ (NSArray *)wy_createNumbers:(NSInteger)number managedObjectInContext:(NSManagedObjectContext *)context;

+ (void)wy_deleteManagedObject:(NSManagedObject *)object InContext:(NSManagedObjectContext *)context;

+ (void)wy_deleteManagedObjects:(NSArray *)objects inContext:(NSManagedObjectContext *)context;

+ (void)wy_deleteManagedObjects:(NSArray *)objects inContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block;

+ (BOOL)wy_deleteMatchingManagedObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

+ (void)wy_deleteMatchingManagedObjects:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block;

+ (void)wy_deleteAllObjectInContext:(NSManagedObjectContext *)context;

+ (NSArray *)wy_fetchAllobjectInContext:(NSManagedObjectContext *)context;

+ (NSArray *)wy_executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)wy_executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block;

@end
