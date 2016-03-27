//
//  BBStepCountingTabBarView.m
//  Basketball
//
//  Created by Allen on 3/4/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingTabBarView.h"

@interface BBStepCountingTabBarView ()

@property (nonatomic, weak) id<BBStepCountingTabBarViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *tabButtons;
@property (strong, nonatomic) UIView *currentTabIndicatorView;
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) UIButton *selectedTabButton;

@end

@implementation BBStepCountingTabBarView

#pragma mark - life cycle

- (instancetype)initWithDelegate:(id<BBStepCountingTabBarViewDelegate>)delegate titles:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupUIWithTitles:titles];
    }
    return self;
}

- (void)updateConstraints {
    NSUInteger totalCount = self.tabButtons.count;
    @weakify(self);
    for (NSInteger index = 0 ; index < totalCount; index++) {

        [self.tabButtons[index] mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.bottom.equalTo(self);
            make.width.equalTo(self).multipliedBy(1.0/totalCount);
            make.centerX.equalTo(self).multipliedBy((1.0+index*2)/totalCount);
        }];
    }
    
    // 这里要用remakeConstaints
    [self.currentTabIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self).mas_offset(-1);
        make.centerX.equalTo(self.selectedTabButton);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(1.5);
    }];
    
    [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [super updateConstraints];
}

#pragma mark - properties

- (NSMutableArray *)tabButtons {
    if (!_tabButtons) {
        _tabButtons = [NSMutableArray new];
    }
    return _tabButtons;
}

#pragma mark - private method

- (void)setupUIWithTitles:(NSArray *)titles {
    
    for (NSInteger index = 0; index < titles.count; index++) {
        UIButton *button = [UIButton new];
        [button setTitle:titles[index] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.tabButtons addObject:button];
    }
    
    //设置当前tab指示view
    self.currentTabIndicatorView = [UIView new];
    self.currentTabIndicatorView.backgroundColor = UIColorFromHex(0xffffff);
    [self addSubview:self.currentTabIndicatorView];
    
    //底部的装饰横线
    self.bottomLineView = [UIView new];
    self.bottomLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomLineView];
    
    self.selectedTabButton = self.tabButtons.firstObject;
}

- (void)tabButtonAction:(UIButton *)button {
    [self selectedTabButtonView:button tapToSelect:YES animate:YES];
}

/**
 *  选中某个tab
 *
 *  @param tabButtonView 选中的tab
 *  @param tapToSelect   是否由点击tabButtonView选中
 */
- (void)selectedTabButtonView:(UIButton *)tabButton tapToSelect:(BOOL)tapToSelect animate:(BOOL)animate {
    for (UIButton *view in self.tabButtons) {
        if (view == tabButton) {
            [view setSelected:YES];
            if (self.delegate && tapToSelect) {
                [self.delegate tabBarView:self didSelectedTabAtIndex:[self.tabButtons indexOfObject:tabButton]];
            }
        }
        else {
            [view setSelected:NO];
        }
    }
    self.selectedTabButton = tabButton;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    if (animate) {
        @weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            @strongify(self);
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - public method

- (void)selectButtonAtIndex:(NSUInteger)index animate:(BOOL)animate{
    if (index >= self.tabButtons.count) {
        return;
    }
    [self selectedTabButtonView:self.tabButtons[index] tapToSelect:NO animate:animate];
}

@end
