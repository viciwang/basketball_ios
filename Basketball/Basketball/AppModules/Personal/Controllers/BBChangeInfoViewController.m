//
//  BBChangeInfoViewController.m
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBChangeInfoViewController.h"
#import "BBCommonCellView.h"
#import "BBUser.h"

@interface BBChangeInfoViewController ()

@property (weak, nonatomic) IBOutlet BBCommonCellView *headImageCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *nickNameCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *cityCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *descriptionCell;

@end

@implementation BBChangeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillData {
    BBUser *user = [BBUser currentUser];
    self.headImageCell.rightImageString = user.headImageUrl;
    self.nickNameCell.rightLabelText = user.nickName;
    self.cityCell.rightLabelText = user.city;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.headImageCell addGestureRecognizer:tap];
    [self.nickNameCell addGestureRecognizer:tap];
    [self.cityCell addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        if (recognizer.view == self.headImageCell) {
            
        }
        else {
            
        }
    }
}

@end
