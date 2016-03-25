//
//  BBPersonalTableViewHeader.h
//  Basketball
//
//  Created by Allen on 3/24/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBUser.h"

@interface BBPersonalTableViewHeaderCell : UITableViewCell

@property (nonatomic, copy) voidBlock changeInfoBlock;

- (void)fillDataWithUser:(BBUser *)user;

@end
