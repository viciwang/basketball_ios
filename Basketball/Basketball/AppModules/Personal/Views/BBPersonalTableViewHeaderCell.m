//
//  BBPersonalTableViewHeader.m
//  Basketball
//
//  Created by Allen on 3/24/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBPersonalTableViewHeaderCell.h"
#import "BBLoginViewController.h"

@interface BBPersonalTableViewHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *personalDescriptionLabel;
@end

@implementation BBPersonalTableViewHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImageView.layer.cornerRadius = 8;
    self.headerImageView.clipsToBounds = YES;
    [self addObserver];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:kBBNotificationUserDidLogin object:nil];
}

- (void)userDidLogin:(NSNotification *)notification {
    [self fillDataWithUser:[BBUser currentUser]];
}

- (void)fillDataWithUser:(BBUser *)user {
    if (user) {
        self.userNameLabel.text = user.nickName;
        self.userNameLabel.userInteractionEnabled = NO;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.headImageUrl]];
        self.personalDescriptionLabel.text = user.personalDescription;
    }
    else {
        self.userNameLabel.userInteractionEnabled = YES;
    }
}

- (IBAction)loginAction:(id)sender {
    [BBLoginViewController showLoginViewControllerWithCompletionBlock:^{
        
    }];
}

- (IBAction)changeInfoAction:(id)sender {
    if (self.changeInfoBlock) {
        self.changeInfoBlock();
    }
}


@end
