//
//  BBStepCountingHistoryRecordCell.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingHistoryRecordCell.h"
#import "BBStepCountingHistoryRecord.h"

@interface BBStepCountingHistoryRecordCell ()
<
ChartViewDelegate
>

@property (weak, nonatomic) IBOutlet BarChartView *chartView;

@end

@implementation BBStepCountingHistoryRecordCell

- (void)awakeFromNib
{
    [self setupChartView];
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
    
    self.chartView.legend.enabled = NO;
}

#pragma mark - data

-(void)updateWithData:(BBStepCountingHistoryMonthRecord *)record {
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < record.dayRecords.count; i++) {
        BBStepCountingHistoryDayRecord *r = record.dayRecords[i];
        [xVals addObject:r.date];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:r.stepCount xIndex:i]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    self.chartView.data = data;
}

#pragma mark - Actions


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
@end
