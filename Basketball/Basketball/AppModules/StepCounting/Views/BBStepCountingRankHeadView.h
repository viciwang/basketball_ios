//
//  BBstepCountingRankHeadView.h
//  Basketball
//
//  Created by Allen on 3/27/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBView.h"
@class BBStepCountingRank;

@interface BBStepCountingRankHeadView : UITableViewCell

- (void)updateWithData:(BBStepCountingRank *)record rate:(CGFloat)rate;

@end
