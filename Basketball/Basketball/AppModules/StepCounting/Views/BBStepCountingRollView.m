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
    CGFloat circleRadius = CGRectGetWidth(self.bounds)*0.5 - self.circleLayer.lineWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.circleLayer.lineWidth, self.circleLayer.lineWidth, circleRadius*2, circleRadius*2)
                                                    cornerRadius:circleRadius];
    self.circleLayer.path = path.CGPath;
    self.backCircleLayer.path = path.CGPath;
}

- (void)refreshWithTodaySteps:(NSUInteger)steps percent:(CGFloat)percent {
    self.todayCountingLabel.text = @(steps).stringValue;
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
        _circleLayer.strokeColor = [UIColor blueColor].CGColor;
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
        _backCircleLayer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.circleLayer]];
        _backCircleLayer.strokeColor = [UIColor grayColor].CGColor;
        _backCircleLayer.zPosition = 0;
        _backCircleLayer.strokeEnd = 1.0;
        [self.layer addSublayer:_backCircleLayer];
    }
    return _backCircleLayer;
}
@end
