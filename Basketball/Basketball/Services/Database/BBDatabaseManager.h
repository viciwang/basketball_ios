//
//  BBDatabaseManager.h
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBUser.h"

@interface BBDatabaseManager : NSObject

+ (BBDatabaseManager *)sharedManager;

- (BBUser *)retriveCurrentUser;

- (BOOL)saveCurrentUser:(BBUser *)user;

@end
