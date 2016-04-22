//
//  BBStartupManager.h
//  Basketball
//
//  Created by Allen on 4/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBStartupManager : NSObject

+ (BBStartupManager *)sharedManager;

- (void)start;

@end
