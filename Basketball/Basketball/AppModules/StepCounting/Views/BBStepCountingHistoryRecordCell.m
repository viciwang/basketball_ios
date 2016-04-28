//
//  BBStepCountingHistoryRecordCell.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingHistoryRecordCell.h"
#import "BBStepCountingHistoryRecord.h"
#import "NSDate+Utilities.h"

@interface BBStepCountingHistoryRecordCell ()
<
ChartViewDelegate
>

@property (weak, nonatomic) IBOutlet BarChartView *chartView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) CAGradientLayer *bgLayer;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (nonatomic, copy) void (^selectedHandler)(NSUInteger decress,NSUInteger index);
@property (nonatomic, assign) NSUInteger descress;

@end

@implementation BBStepCountingHistoryRecordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 7.0;
    self.bgView.clipsToBounds = YES;
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    [self.bgView.layer addSublayer:gLayer];
    
    gLayer.colors = @[(__bridge id)UIColorFromHex(0x045f82).CGColor,(__bridge id)UIColorFromHex(0x2ec0f8).CGColor];
    gLayer.startPoint = CGPointMake(0, 1);
    gLayer.endPoint = CGPointMake(0, 0);
    gLayer.zPosition = -1;
    self.bgLayer = gLayer;
    [self setupChartView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgLayer.frame = CGRectMake(0, 0, 500, 200);//self.bgView.bounds;
//    NSLog(@"%@",NSStringFromCGRect(self.bgView.bounds));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)setupChartView {
    
    self.chartView.delegate = self;
    
    self.chartView.descriptionText = @"";
    self.chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    self.chartView.maxVisibleValueCount = 60;
    self.chartView.pinchZoomEnabled = NO;
    self.chartView.drawBarShadowEnabled = NO;
    self.chartView.drawGridBackgroundEnabled = NO;
    
    self.chartView.leftAxis.enabled = NO;
    self.chartView.rightAxis.enabled = NO;
    self.chartView.xAxis.enabled = NO;
    
    self.chartView.legend.enabled = NO;
    self.chartView.scaleXEnabled = NO;
    self.chartView.scaleYEnabled = NO;
}

#pragma mark - data

- (void)updateWithData:(BBStepCountingHistoryMonthRecord *)record isLastCell:(BOOL)isLastCell selectedHandler:(void (^)(NSUInteger, NSUInteger))handler {
    self.selectedHandler = handler;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM";
    NSDate *date = [formatter dateFromString:record.month];
    self.monthLabel.text = [date stringWithFormat:@"YYYY年MM月"];
    
    self.averageLabel.text = @(record.average).stringValue;
    
    
    NSRange range = [[NSDate currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger daysOfMonth = range.length;
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    int i = 0;
    self.descress = daysOfMonth - record.dayRecords.count;
    if (self.descress>0 && isLastCell) {
        for (i = 0; i < self.descress; i++) {
            [xVals addObject:@(i)];
            [yVals addObject:[[BarChartDataEntry alloc] initWithValue:0 xIndex:i]];
        }
        self.descress = daysOfMonth - record.dayRecords.count;
    }
    else {
        self.descress = 0;
    }
    for (; i < daysOfMonth; i++) {
        NSUInteger index = i - self.descress;
        [xVals addObject:@(i)];
        if (index <record.dayRecords.count) {
            BBStepCountingHistoryDayRecord *r = record.dayRecords[record.dayRecords.count - 1 - index];
            [yVals addObject:[[BarChartDataEntry alloc] initWithValue:r.stepCount xIndex:i]];
        }
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.colors = @[UIColorFromHexWithAlpha(0xffff92, 0.5)];
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    self.chartView.data = data;
}

#pragma mark - Actions


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    self.selectedHandler(self.descress,entry.xIndex);
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
@end
