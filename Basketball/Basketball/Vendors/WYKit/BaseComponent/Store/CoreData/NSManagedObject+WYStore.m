//
//  NSManagedObject+WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/6.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSManagedObject+WYStore.h"
#import "WYStore+Option.h"
#import "NSManagedObject+WYStoreFetch.h"

static void executeBlockInMainThread(void(^block)()) {
    
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    } else {
        block();
    }
}

@implementation NSManagedObject(WYStore)

+ (NSString *)wy_entityName {
    
    NSString *entityName;
    
    if ([self respondsToSelector:@selector(entityName)]) {
        entityName = [self performSelector:@selector(entityName)];
    }
    
    if (!entityName || entityName.length<1) {
        entityName = [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] firstObject];
    }
    
    return entityName;
}

+ (instancetype)wy_createManagedObjectInContext:(NSManagedObjectContext *)context {
    
    id result = [self wy_createNumbers:1 managedObjectInContext:context];
    
    return result?[result firstObject]:nil;
}

+ (NSArray *)wy_createNumbers:(NSInteger)number managedObjectInContext:(NSManagedObjectContext *)context {
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:[self wy_entityName]
                                                  inManagedObjectContext:context];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    id newObject;
    
    while (number) {
        newObject = [[self alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
        if (newObject) {
            [array addObject:newObject];
            number--;
        }
    }
    if (!array.count) {
        array = nil;
    }
    return array;
}

+ (void)wy_deleteManagedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context {
    [self wy_deleteManagedObjects:@[object] inContext:context];
}


+ (void)wy_deleteManagedObjects:(NSArray *)objects inContext:(NSManagedObjectContext *)context {
    [self wy_deleteManagedObjects:objects
                               inContext:context
                                  option:WYStoreOperationSync
                              completion:nil];
}

+ (void)wy_deleteManagedObjects:(NSArray *)objects inContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block {
    [self wy_deleteManagedObjects:objects
                        inContext:context
                           option:WYStoreOperationAsync
                       completion:block];
}

+ (BOOL)wy_deleteMatchingManagedObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context {
    
    NSArray *resultArray = [self wy_executeFetchRequest:request inManagedObjectContext:context];
    if (!resultArray) {
        return NO;
    }
    [self wy_deleteManagedObjects:resultArray inContext:context];
    return YES;
}

+ (void)wy_deleteMatchingManagedObjects:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block {
    [self wy_executeFetchRequest:request inManagedObjectContext:context
                      completion:^(id object, BOOL success, NSError *error) {
                          if (!object) {
                              executeBlockInMainThread(^{
                                  block(nil, NO, error);
                              });
                          }
                          
                          [self wy_deleteManagedObjects:object
                                              inContext:context
                                             completion:block];
                      }];
}

+ (void)wy_deleteManagedObjects:(NSArray *)objects inContext:(NSManagedObjectContext *)context option:(WYStoreOperationOption)opt completion:(WYStoreManagedObjectOperationCompletionBlock)block {
    
    id deleteBlock = ^{
        
        for (NSManagedObject *obj in objects) {
            [context deleteObject:obj];
        }
        
        if (block) {
            executeBlockInMainThread(^{
                block(nil,YES,nil);
            });
        }
    };
    
    if (opt&WYStoreOperationAsync) {
        [context performBlock:deleteBlock];
    } else {
        [context performBlockAndWait:deleteBlock];
    }
}

+ (void)wy_deleteAllObjectInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self wy_allObjectFetchRequest];
    [request setReturnsObjectsAsFaults:YES];
    [request setPropertiesToFetch:nil];
    
    NSArray *deleteObjects = [self wy_executeFetchRequest:request inManagedObjectContext:context];
    
    [self wy_deleteManagedObjects:deleteObjects inContext:context];
}

+ (NSArray *)wy_fetchAllobjectInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self wy_allObjectFetchRequest];
    
    return [self wy_executeFetchRequest:request inManagedObjectContext:context];
}

+ (NSArray *)wy_executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context {

    return [self wy_executeFetchRequest:request
                 inManagedObjectContext:context
                                 option:WYStoreOperationSync
                             completion:nil];
}

+ (void)wy_executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context completion:(WYStoreManagedObjectOperationCompletionBlock)block {
    
    [self wy_executeFetchRequest:request
          inManagedObjectContext:context
                          option:WYStoreOperationAsync
                      completion:block];
}

+ (id)wy_executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context option:(WYStoreOperationOption)opt completion:(WYStoreManagedObjectOperationCompletionBlock)block {
    
    __block NSArray *resultArray;
    __block NSError *error;
    __block BOOL success;
    
    if (WYStoreOperationAsync&opt) {
        
        [context performBlock:^{
            
            resultArray = [context executeFetchRequest:request
                                                 error:&error];
            
            
            success = error?NO:YES;
            
            if (!block) {
                return;
            }
            if (![NSThread isMainThread]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(resultArray,success,error);
                });
            } else {
                block(resultArray,success,error);
            }
        }];
        return nil;
    } else {
        [context performBlockAndWait:^{
            resultArray = [context executeFetchRequest:request
                                                 error:&error];
        }];
    }
    resultArray = [NSArray arrayWithArray:resultArray];
    return resultArray;
}

@end
