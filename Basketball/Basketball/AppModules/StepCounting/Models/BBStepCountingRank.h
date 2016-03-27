//
//  BBStepCountingRank.h
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBModel.h"

@interface BBStepCountingRank : BBModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImageUrl;
@property (nonatomic, assign) NSUInteger stepCount;
@property (nonatomic, copy) NSString *personalDescription;
@property (nonatomic, assign) NSUInteger rank;

@end

@interface BBStepCountingRankResponse : BBModel

@property (nonatomic, strong) BBStepCountingRank *myRank;
@property (nonatomic, strong) NSArray *ranks;

@end
