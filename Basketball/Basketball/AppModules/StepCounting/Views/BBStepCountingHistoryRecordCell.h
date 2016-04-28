//
//  BBStepCountingHistoryRecordCell.h
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBStepCountingHistoryRecord.h"

@interface BBStepCountingHistoryRecordCell : UITableViewCell

- (void)updateWithData:(BBStepCountingHistoryMonthRecord *)record isLastCell:(BOOL)isLastCell selectedHandler:(void (^)(NSUInteger descress,NSUInteger index)) handler;

@end
