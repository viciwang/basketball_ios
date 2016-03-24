//
//  BBPersonalCenterCell.h
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBPersonalCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic, assign) BOOL isLastIndexInSection;

@end
