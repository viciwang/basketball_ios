//
//  BBStepCountingRankCell.h
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBStepCountingRank.h"

@interface BBStepCountingRankCell : UITableViewCell

- (void)updateWithData:(BBStepCountingRank *)record;

@end
