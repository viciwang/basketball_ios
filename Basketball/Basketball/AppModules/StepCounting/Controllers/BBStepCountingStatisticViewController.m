//
//  BBStepCountingStatisticViewController.m
//  Basketball
//
//  Created by Allen on 3/4/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingStatisticViewController.h"
#import "BBStepCountingManager.h"

@interface CubicLineSampleFillFormatter : NSObject <ChartFillFormatter>
{
}
@end

@implementation CubicLineSampleFillFormatter

- (CGFloat)getFillLinePositionWithDataSet:(LineChartDataSet *)dataSet dataProvider:(id<LineChartDataProvider>)dataProvider
{
    return -10.f;
}

@end

@interface BBStepCountingStatisticViewController ()
<
    ChartViewDelegate
>

@property (nonatomic, assign) BBStepCountingStatisticType statisticsType;
@property (nonatomic, strong) LineChartView *chartView;

@end

@implementation BBStepCountingStatisticViewController

- (instancetype)initWithStatisticsType:(BBStepCountingStatisticType)type {
    self = [super init];
    if (self) {
        self.statisticsType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(arc4random()%0xffffff);
    [self setupChartView];
    [self updateChartData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints {
    @weakify(self);
    [self.chartView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.chartView.superview);
        make.height.equalTo(self.chartView.superview).multipliedBy(0.5);
    }];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - chartView

- (void)setupChartView {
    self.chartView = [LineChartView new];
    [self.view addSubview:self.chartView];
    
    self.chartView.delegate = self;
    
    self.chartView.descriptionText = @"";
    self.chartView.noDataTextDescription = @"暂无相关数据";
    
    self.chartView.dragEnabled = YES;
    [self.chartView setScaleEnabled:YES];
    self.chartView.pinchZoomEnabled = NO;
    self.chartView.drawGridBackgroundEnabled = NO;
    
    ChartYAxis *leftAxis = self.chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMin = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.labelTextColor = [UIColor whiteColor];
    leftAxis.labelPosition = 
    
    self.chartView.rightAxis.enabled = NO;
    self.chartView.legend.enabled = NO;
    
    self.chartView.xAxis.labelPosition = XAxisLabelPositionTop;
    self.chartView.xAxis.labelTextColor =[UIColor whiteColor];
}

- (void)updateChartData {
    @weakify(self);
    [[BBStepCountingManager sharedManager] queryStepsOfToday:^(NSArray *steps) {
        @strongify(self);
        [self updateTodayData:steps];
        [self.chartView animateWithXAxisDuration:2.0];
    }];
}

- (void)updateTodayData:(NSArray *)data {
    NSMutableArray *xValues = [NSMutableArray new];
    for (NSInteger index = 0; index < data.count; index++) {
        [xValues addObject:@(index).stringValue];
    }
    
    NSMutableArray *yValues = [NSMutableArray new];
    for (NSInteger index = 0; index < data.count; index++) {
        DDLogInfo(@"%@",@([data[index] doubleValue]));
        [yValues addObject:[[ChartDataEntry alloc] initWithValue:[data[index] doubleValue] xIndex:index]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yValues label:@"DataSet 1"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:[UIColor whiteColor]];
    [set1 setCircleColor:[UIColor whiteColor]];
    set1.drawCirclesEnabled = NO;
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    //set1.fillAlpha = 65/255.0;
    //set1.fillColor = UIColor.blackColor;
    
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
