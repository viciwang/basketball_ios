//
//  NSManagedObjectContext+WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+WYStore.h"
#import "NSManagedObject+WYStoreFetch.h"

typedef void(^WYManagedObjectContextSaveBlock)(NSManagedObjectContext *block);
typedef void(^WYManagedObjectContextSaveCompletionBlock)(id object,BOOL success,NSError *error);

@interface NSManagedObjectContext(WYStore)


/**
 *	a main queue ManagedObjectContext
 *
 *	@return the default ManagedObjectContext
 */
+ (NSManagedObjectContext *)wy_defaultManagedObjectContext;
/**
 *	the root a main queue ManagedObjectContext,
 *  a private queue context for saving final data change to persistent store
 *
 *	@return root managed object context
 */
+ (NSManagedObjectContext *)wy_rootManagedObjectContext;
/**
 *	create a main queue ManagedObjectContext
 *
 *	@return a main queue ManagedObjectContext
 */
+ (NSManagedObjectContext *)wy_createMainQueueManagedObjectContext;
/**
 *	create a private queue ManagedObjectContext
 *
 *	@return a private queue context
 */
+ (NSManagedObjectContext *)wy_createPrivateQueueManagedObjectContext;
/**
 *	add a parent context to the current context
 *
 *	@param parentContext	parent context
 */
- (void)wy_setParentContext:(NSManagedObjectContext *)parentContext;
/**
 *	add a persistent store coordinator to current context
 *
 *	@param coordinator	the coordinator
 */
- (void)wy_addPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
/**
 *	only save self context syncronize
 */
- (BOOL)wy_saveForSelf;
/**
 *	only save self context asyncronize
 */
- (void)wy_saveForSelfCompletion:(WYManagedObjectContextSaveCompletionBlock)block;
/**
 *	save from self to the root context by the context chain syncronize
 */
- (BOOL)wy_saveToRootContext;
/**
 *	save from self to the root context by the context chain asyncronize
 */
- (void)wy_saveToRootContextCompletion:(WYManagedObjectContextSaveCompletionBlock)block;

@end
