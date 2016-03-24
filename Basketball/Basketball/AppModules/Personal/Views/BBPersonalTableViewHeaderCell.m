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
@property (weak, nonatomic) IBOutlet UIButton *loginOrUserNameButton;
@property (weak, nonatomic) IBOutlet UIButton *changeInfoButton;

@end

@implementation BBPersonalTableViewHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        [self.loginOrUserNameButton setTitle:user.nickName forState:UIControlStateNormal];
        self.loginOrUserNameButton.userInteractionEnabled = NO;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.headImageUrl]];
    }
    else {
        [self.loginOrUserNameButton setTitle:@"立即登录" forState:UIControlStateNormal];
        self.loginOrUserNameButton.userInteractionEnabled = YES;
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
