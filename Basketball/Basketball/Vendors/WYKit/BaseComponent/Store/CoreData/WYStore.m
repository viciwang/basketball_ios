//
//  WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYStore.h"
#import "NSManagedObjectContext+WYStore.h"
#import "NSPersistentStoreCoordinator+WYStore.h"

@implementation WYStore

+ (void)wy_setupDefaultStoreStack {
    
    NSManagedObjectContext *root = [NSManagedObjectContext wy_rootManagedObjectContext];
    NSPersistentStoreCoordinator *defaultPSC = [NSPersistentStoreCoordinator wy_defaultPersistentStoreCoordinator];
    [defaultPSC wy_addStore];
    [root wy_addPersistentStoreCoordinator:defaultPSC];
}

+ (void)wy_saveToDisk:(WYStoreSaveBlock)saveBlock completion:(WYStoreSaveCompletionBlock)completionBlock {
    
    NSManagedObjectContext *context = [NSManagedObjectContext wy_createPrivateQueueManagedObjectContext];
    [context wy_setParentContext:[NSManagedObjectContext wy_rootManagedObjectContext]];
    
    [self wy_saveToDisk:saveBlock inContext:context completion:completionBlock];
}

+ (void)wy_saveToDisk:(WYStoreSaveBlock)saveBlock inContext:(NSManagedObjectContext *)ctxt completion:(WYStoreSaveCompletionBlock)completionBlock {
    
    [ctxt performBlock:^{
        
        if (saveBlock) {
            saveBlock(ctxt);
        }
        
        [ctxt wy_saveToRootContextCompletion:completionBlock];
    }];
}

+ (BOOL)wy_saveToDiskSyncronize:(WYStoreSaveBlock)saveBlock {
    
    NSManagedObjectContext *context = [NSManagedObjectContext wy_createPrivateQueueManagedObjectContext];
    [context wy_setParentContext:[NSManagedObjectContext wy_rootManagedObjectContext]];
    
    return [self wy_saveToDiskSyncronize:saveBlock inContext:context];
}

+ (BOOL)wy_saveToDiskSyncronize:(WYStoreSaveBlock)saveBlock inContext:(NSManagedObjectContext *)ctxt {
    
    __block BOOL saveSuccess = NO;
    
    [ctxt performBlockAndWait:^{
        
        if (saveBlock) {
            saveBlock(ctxt);
        }
        
        saveSuccess = [ctxt wy_saveToRootContext];
    }];
    
    return saveSuccess;
}

@end
