//
//  NSManagedObjectContext+WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSManagedObjectContext+WYStore.h"
#import "NSPersistentStoreCoordinator+WYStore.h"

static NSManagedObjectContext *WYDefaultManagedObjectContext;
static NSManagedObjectContext *WYRootManagedObjectContext;

typedef BOOL(^WYManagedObjectContextPrivateSaveBlock)();

@implementation NSManagedObjectContext(WYStore)

+ (NSManagedObjectContext *)wy_defaultManagedObjectContext {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        WYDefaultManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [WYDefaultManagedObjectContext setParentContext:[self wy_rootManagedObjectContext]];
        [WYDefaultManagedObjectContext wy_configDefaultManagedObjectContext];
    });
    return WYDefaultManagedObjectContext;
}

- (void)wy_rootContextWillSaveNotification:(NSNotification *)notification {
    
    NSManagedObjectContext *rootContext = [notification object];
    if(rootContext != WYRootManagedObjectContext)
        return;
    //we know cocoa notification is send on the same thread
    //if the current is not main thread for the context
    //perform it on main thread
    if(![NSThread isMainThread]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self wy_rootContextWillSaveNotification:notification];
        });
        
        return;
    }
    
    for (NSManagedObject *obj in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
        [[WYDefaultManagedObjectContext objectWithID:obj.objectID] willAccessValueForKey:nil];
    }
    
    [WYDefaultManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}
- (void)wy_configDefaultManagedObjectContext {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wy_rootContextWillSaveNotification:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:WYRootManagedObjectContext];
}

+ (NSManagedObjectContext *)wy_rootManagedObjectContext {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        WYRootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [WYRootManagedObjectContext setPersistentStoreCoordinator:[NSPersistentStoreCoordinator wy_defaultPersistentStoreCoordinator]];
    });
    return WYRootManagedObjectContext;
}

+ (NSManagedObjectContext *)wy_createMainQueueManagedObjectContext {
    
    return [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
}

+ (NSManagedObjectContext *)wy_createPrivateQueueManagedObjectContext {
    
    return [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
}

- (void)wy_setParentContext:(NSManagedObjectContext *)parentContext {
    
    [self setParentContext:parentContext];
}

- (void)wy_addPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator {
    
    [self setPersistentStoreCoordinator:coordinator];
}

- (BOOL)wy_saveToRoot:(BOOL)isSaveToRoot asyncronize:(BOOL)async completionBlock:(WYManagedObjectContextSaveCompletionBlock)completionBlock {
    
    __block BOOL hasChange = NO;
    [self performBlockAndWait:^{
        hasChange = [self hasChanges];
    }];
    
    isSaveToRoot = (isSaveToRoot&&[self parentContext]);
    
    WYManagedObjectContextPrivateSaveBlock saveBlock = ^BOOL{
        
        if (!hasChange) {
            return YES;
        }
        
        BOOL saveSuccess = nil;
        NSError *error = nil;
        
        @try {
            saveSuccess = [self save:&error];
        }
        @catch (NSException *exception) {
        }
        @finally {
            if (saveSuccess) {
                if (isSaveToRoot) {
                    saveSuccess = [[self parentContext] wy_saveToRoot:YES asyncronize:NO completionBlock:nil];
                }
            }
            error = saveSuccess?nil:error;
            if (async&&completionBlock) {
                completionBlock(nil,saveSuccess,error);
            }
            if (!async&&!saveSuccess) {
                return NO;
            }
        }
        
        return YES;
    };
    
    __block BOOL result = NO;
    if (async) {
        [self performBlock:^{
            saveBlock();
        }];
    } else {
        [self performBlockAndWait:^{
            result = saveBlock();
        }];
    }
    return result;
}

- (BOOL)wy_saveForSelf {
    return [self wy_saveToRoot:NO asyncronize:NO completionBlock:nil];
}

- (void)wy_saveForSelfCompletion:(WYManagedObjectContextSaveCompletionBlock)block {
    [self wy_saveToRoot:NO asyncronize:YES completionBlock:block];
}

- (BOOL)wy_saveToRootContext {
    return [self wy_saveToRoot:YES asyncronize:NO completionBlock:nil];
}

- (void)wy_saveToRootContextCompletion:(WYManagedObjectContextSaveCompletionBlock)block {
    [self wy_saveToRoot:YES asyncronize:YES completionBlock:block];
}

@end
