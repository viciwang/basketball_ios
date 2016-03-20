//
//  BBStepCountingChartView.m
//  Basketball
//
//  Created by Allen on 3/19/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingChartView.h"
#import "BBStepCountingManager.h"
#import "NSDate+Utilities.h"

@interface BBStepCountingChartView ()
<
ChartViewDelegate
>


@property (nonatomic, strong) LineChartView *chartView;

@end

@implementation BBStepCountingChartView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromHex(arc4random()%0xffffff);
        [self setupChartView];
    }
    return self;
}


- (void)updateConstraints {
    @weakify(self);
    [self.chartView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.chartView.superview);
    }];
    [super updateConstraints];
}

#pragma mark - chartView

- (void)setupChartView {
    self.chartView = [LineChartView new];
    [self addSubview:self.chartView];
    
    self.chartView.delegate = self;
    
    self.chartView.descriptionText = @"";
    self.chartView.noDataTextDescription = @"暂无相关数据";
    
    self.chartView.dragEnabled = NO;
    [self.chartView setScaleEnabled:NO];
    self.chartView.pinchZoomEnabled = NO;
    self.chartView.drawGridBackgroundEnabled = NO;
    
    self.chartView.leftAxis.enabled = NO;
    self.chartView.rightAxis.enabled = NO;
    self.chartView.legend.enabled = NO;
    self.chartView.xAxis.enabled = YES;
    self.chartView.xAxis.drawGridLinesEnabled = NO;
    self.chartView.xAxis.drawAxisLineEnabled = NO;
    self.chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    self.chartView.xAxis.labelTextColor =[UIColor whiteColor];
}

- (void)refreshWithData:(NSArray *)steps {
    [self updateTodayData:steps];
    [self.chartView animateWithYAxisDuration:1.0];
}

- (void)updateTodayData:(NSArray *)data {
    NSMutableArray *xValues = [NSMutableArray new];
    for (NSInteger index = 0; index < data.count; index++) {
        [xValues addObject:@(index).stringValue];
    }
    
    NSMutableArray *yValues = [NSMutableArray new];
    double lastStepCount = 0;
    for (NSInteger index = 0; index < data.count; index++) {
        NSUInteger hour = [[NSDate date] hour];
        if (index > hour) {
            break;
        }
        double stepCount = [data[index] doubleValue];
        if (stepCount < 1) {
            stepCount = lastStepCount * 0.5;
        }
        if (stepCount >= 1) {
            [yValues addObject:[[ChartDataEntry alloc] initWithValue:stepCount xIndex:index]];
        }
        lastStepCount = [data[index] doubleValue];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yValues label:@"DataSet 1"];
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.drawCubicEnabled = NO;
    set1.cubicIntensity = 0.2;
    set1.drawCirclesEnabled = YES;
    set1.lineWidth = 0.5;
    set1.circleRadius = 2;
    [set1 setCircleColor:UIColor.whiteColor];
    set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    [set1 setColor:UIColor.whiteColor];
    set1.fillColor = UIColor.whiteColor;
    set1.fillAlpha = 1.f;
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    [set1 setDrawValuesEnabled:NO];
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *d = [[LineChartData alloc] initWithXVals:xValues dataSets:dataSets];
    
    self.chartView.data = d;
}


@end
