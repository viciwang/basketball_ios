//
//  WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+WYStore.h"


typedef void(^WYStoreSaveBlock)(id);
typedef void(^WYStoreSaveCompletionBlock)(id, BOOL, NSError*);

@interface WYStore : NSObject
/**
 *	setup the core data stack
 *  include a root moc, main queue moc and a private queue moc if need
 */
+ (void)wy_setupDefaultStoreStack;
/**
 *	save for the context chain until the root context for saving to disk
 *
 *	@param saveBlock				do something in this block for the context which will be saved
 *	@param completionBlock	the completion block
 */
+ (void)wy_saveToDisk:(WYStoreSaveBlock)saveBlock completion:(WYStoreSaveCompletionBlock)completionBlock;
+ (void)wy_saveToDisk:(WYStoreSaveBlock)saveBlock inContext:(NSManagedObjectContext *)ctxt completion:(WYStoreSaveCompletionBlock)completionBlock;
/**
 *	save for the context chain until the root context for saving to disk
 *
 *	@param saveBlock	do something in this block for the context which will be saved
 *
 *	@return save success or not
 */
+ (BOOL)wy_saveToDiskSyncronize:(WYStoreSaveBlock)saveBlock;
+ (BOOL)wy_saveToDiskSyncronize:(WYStoreSaveBlock)saveBlock inContext:(NSManagedObjectContext *)ctxt;

@end
