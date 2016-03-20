//
//  NSManagedObject+WYStoreFetch.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/6.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(WYStoreFetch)

+ (NSFetchRequest *)wy_allObjectFetchRequest;
+ (NSFetchRequest *)wy_allObjectFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)wy_fetchRequestAtObjectsRange:(NSRange)range;
+ (NSFetchRequest *)wy_fetchRequestAtObjectsRange:(NSRange)range inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate;
+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate objectRange:(NSRange)range;
+ (NSFetchRequest *)wy_fetchRequestWithPridicate:(NSPredicate *)predicate objectRange:(NSRange)range inContext:(NSManagedObjectContext *)context;

@end
