//
//  BBCommonCellView.m
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBCommonCellView.h"

@interface BBCommonCellView ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *disclosureIndicatorImageView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation BBCommonCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configSubView];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self configSubView];
    }
    return self;
}

- (void)updateConstraints {
    @weakify(self);
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (self.leftImage || self.leftImageString) {
            make.left.equalTo(self).offset(62);
        }
        else {
            make.left.equalTo(self).offset(21);
        }
        make.centerY.equalTo(self);
    }];
    
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        CGFloat rightSpace = 21;
        if (self.shouldShowdisclosureIndicator) {
            rightSpace += 41;
        }
        if (self.rightImage || self.rightImageString) {
            rightSpace += 41;
        }
        make.right.equalTo(self).offset(-rightSpace);
        make.centerY.equalTo(self);
    }];
    
    [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(21);
        make.centerY.equalTo(self);
    }];
    
    [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (self.shouldShowdisclosureIndicator) {
            make.right.equalTo(self).offset(-62);
        }
        else {
            make.right.equalTo(self).offset(-21);
        }
        make.centerY.equalTo(self);
    }];
    
    [self.disclosureIndicatorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-21);
        make.centerY.equalTo(self);
    }];
    
    [self.topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@(0.5));
        make.left.equalTo(self).offset(self.topLineLeftSpace);
        make.right.equalTo(self).offset(-self.topLineRightSpace);
        make.top.equalTo(self);
    }];
    
    [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@0.5);
        make.left.equalTo(self).offset(self.bottomLineLeftSpace);
        make.right.equalTo(self).offset(-self.bottomLineRightSpace);
        make.bottom.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)configSubView {
    self.leftLabel = [self commonLabel];
    self.leftLabelText = self.leftLabelText;
    
    self.rightLabel = [self commonLabel];
    self.rightLabelText = self.rightLabelText;
    
    self.leftImageView = [UIImageView new];
    if (self.leftImageString) {
        self.leftImageString = self.leftImageString;
    }
    else {
        self.leftImage = self.leftImage;
    }
    
    self.rightImageView = [UIImageView new];
    if (self.rightImageString) {
        self.rightImageString = self.rightImageString;
    }
    else {
        self.rightImage = self.rightImage;
    }
    
    self.disclosureIndicatorImageView = [UIImageView new];
    self.disclosureIndicatorImageView.image = [UIImage imageNamed:@"Right Arrow 2"];
    self.shouldShowdisclosureIndicator = self.shouldShowdisclosureIndicator;
    
    self.topLine = [UIView new];
    self.topLine.backgroundColor = UIColorFromHex(0xd5d5d5);
    self.shouldShowTopLine = self.shouldShowTopLine;
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = UIColorFromHex(0xd5d5d5);
    self.shouldShowBottomLine = self.shouldShowBottomLine;
    
    NSArray *array = @[self.leftLabel,self.rightLabel,self.leftImageView, \
                       self.rightImageView,self.disclosureIndicatorImageView,self.topLine,self.bottomLine];
    for (UIView *v in array) {
        [self addSubview:v];
    }
}

- (UILabel *)commonLabel {
    UILabel *label = [UILabel new];
    label.textColor = baseFontColor;
    label.font = baseFontOfSize(15);
    return label;
}

#pragma mark - properties

- (void)setLeftLabelText:(NSString *)leftLabelText {
    _leftLabelText = leftLabelText;
    self.leftLabel.text = leftLabelText;
}

- (void)setRightLabelText:(NSString *)rightLabelText {
    _rightLabelText = rightLabelText;
    self.rightLabel.text = rightLabelText;
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    self.leftImageView.image = leftImage;
}

- (void)setRightImage:(UIImage *)rightImage {
    _rightImage = rightImage;
    self.rightImageView.image = rightImage;
    self.rightImageView.hidden = NO;
}

- (void)setLeftImageString:(NSString *)leftImageString {
    _leftImageString = leftImageString;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImageString]];
}

- (void)setRightImageString:(NSString *)rightImageString {
    _rightImageString = rightImageString;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImageString]];
}

- (void)setShouldShowTopLine:(BOOL)shouldShowTopLine {
    _shouldShowTopLine = shouldShowTopLine;
    self.topLine.hidden = !shouldShowTopLine;
}

- (void)setShouldShowBottomLine:(BOOL)shouldShowBottomLine {
    _shouldShowBottomLine = shouldShowBottomLine;
    self.bottomLine.hidden = !shouldShowBottomLine;
}

- (void)setShouldShowdisclosureIndicator:(BOOL)shouldShowdisclosureIndicator {
    _shouldShowdisclosureIndicator = shouldShowdisclosureIndicator;
    self.disclosureIndicatorImageView.hidden = !shouldShowdisclosureIndicator;
}

@end
