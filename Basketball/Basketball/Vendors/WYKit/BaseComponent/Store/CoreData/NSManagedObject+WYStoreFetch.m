//
//  NSManagedObject+WYStoreFetch.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/6.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSManagedObject+WYStoreFetch.h"
#import "NSManagedObject+WYStore.h"

@implementation NSManagedObject(WYStoreFetch)

+ (NSFetchRequest *)wy_allObjectFetchRequest {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self wy_entityName]];
    
    return request;
}

+ (NSFetchRequest *)wy_allObjectFetchRequestInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *description = [NSEntityDescription entityForName:[self wy_entityName]
                                                   inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    return request;
}

+ (NSFetchRequest *)wy_fetchRequestAtObjectsRange:(NSRange)range inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self wy_allObjectFetchRequestInContext:context];
    
    request.fetchOffset = range.location;
    
    if (range.length>0) {
        request.fetchLimit = range.length;
    }
    
    return request;
}

+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self wy_allObjectFetchRequestInContext:context];
    if (predicate) {
        request.predicate = predicate;
    }
    
    return request;
}

+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate objectRange:(NSRange)range inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self wy_fetchRequestAtObjectsRange:range  inContext:context];
    if (predicate) {
        request.predicate = predicate;
    }
    
    return request;
}

@end
