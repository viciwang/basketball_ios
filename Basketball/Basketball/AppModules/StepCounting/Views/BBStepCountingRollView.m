//
//  BBStepCountingRollView.m
//  Basketball
//
//  Created by Allen on 3/18/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingRollView.h"

@interface BBStepCountingRollView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *backCircleLayer;
@property (nonatomic, weak) IBOutlet UILabel *todayCountingLabel;
@property (nonatomic, weak) IBOutlet UILabel *describeLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageLabel;

@end

@implementation BBStepCountingRollView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configCircle:self.circleLayer offset:self.backCircleLayer.lineWidth - self.circleLayer.lineWidth];
    [self configCircle:self.backCircleLayer offset:0];
}

- (void)configCircle:(CAShapeLayer *)circleLayer offset:(CGFloat)offset {
    CGFloat circleRadius = CGRectGetWidth(self.bounds)*0.5 - circleLayer.lineWidth - offset;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(circleLayer.lineWidth + offset, circleLayer.lineWidth + offset, circleRadius*2, circleRadius*2)
                                                    cornerRadius:circleRadius];
    circleLayer.path = path.CGPath;
}

- (void)refreshWithTodayStep:(NSUInteger)step average:(NSUInteger)average {
    self.todayCountingLabel.text = @(step).stringValue;
    self.averageLabel.text = [NSString stringWithFormat:@"日平均值：%@步",@(average).stringValue];
    
    CGFloat percent = step>average ? 1.0 : @(step).floatValue/average;
    self.circleLayer.strokeEnd = percent;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @(percent);
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circleLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.strokeColor = UIColorFromHex(0xffaa80).CGColor;
        _circleLayer.lineWidth = 10.0;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.zPosition = 1;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)backCircleLayer {
    if (!_backCircleLayer) {
        _backCircleLayer = [CAShapeLayer layer];
        _backCircleLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        _backCircleLayer.lineWidth = 20.0;
        _backCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _backCircleLayer.zPosition = 0;
        _backCircleLayer.strokeEnd = 1.0;
        [self.layer addSublayer:_backCircleLayer];
    }
    return _backCircleLayer;
}
@end
