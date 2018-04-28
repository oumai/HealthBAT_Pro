//
//  BATHealthThreeSecondsCalendarController.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsCalendarController.h"
#import "FSCalendar.h"
#import "UIColor+Gradient.h"

#define YYMMDD @"YYYY-MM-dd"
#define YYMM @"YYYY-MM"

@interface BATHealthThreeSecondsCalendarController ()<FSCalendarDataSource, FSCalendarDelegate>
@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@end

@implementation BATHealthThreeSecondsCalendarController
- (void)dealloc{
    
    DDLogDebug(@"===BATHealthThreeSecondsCalendarController====dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日期选择";
    self.view.backgroundColor = [UIColor whiteColor];
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    
    UIColor *todayColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:calendar.rowHeight];
    UIColor *selColor = [UIColor gradientFromColor:UIColorFromHEX(0xe7a21d, 1) toColor:UIColorFromHEX(0xeacd31, 1) withHeight:calendar.rowHeight];
    
    NSString *todyStr =  [self dateConverStr:[NSDate date] dateFormat:YYMMDD];
    
    //设置默认选中时间
    if (![todyStr isEqualToString:_selectedDateStr]) {
        [calendar selectDate:[self dateStrConverDate:_selectedDateStr dateFormat:YYMMDD]];
    }
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    calendar.appearance.todayColor = todayColor;
    calendar.appearance.selectionColor = selColor;
    calendar.appearance.weekdayTextColor = UIColorFromHEX(0x333333, 1);
    calendar.appearance.headerTitleColor = UIColorFromHEX(0x333333, 1);
    
    self.calendar = calendar;
    [self.view addSubview:calendar];
   
    //昨天
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 0, 95, 34);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;

    //明天
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(SCREEN_WIDTH-95, 0, 95, 34);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"disable_right_ arrow"] forState:UIControlStateDisabled];
    nextButton.enabled = NO;
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    //确定按钮

    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromHEX(0x6ccc56, 1) forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromHEX(0x6ccc56, 1) forState:UIControlStateHighlighted];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}
- (void)sureButtonClick{
    if (self.backBlock) {
        self.backBlock(self.selectedDateStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)previousClicked:(id)sender
{
    self.nextButton.enabled = YES;
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];

    [self setupNextButtonStatusWithDate:nextMonth];

}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{

    
    self.selectedDateStr = [self dateConverStr:date dateFormat:YYMMDD];
    [self setupNextButtonStatusWithDate:date];
    
}

- (void)setupNextButtonStatusWithDate:(NSDate *)date{
    
    NSString *nextMonthStr = [self dateConverStr:date dateFormat:YYMM];
    NSString *currentMonthStr = [self dateConverStr:[NSDate date] dateFormat:YYMM];
    
    self.nextButton.enabled = [nextMonthStr isEqualToString:currentMonthStr] ? NO : YES;
    
    
}
- (NSString *)dateConverStr:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    return [formatter stringFromDate:date];
    
}

- (NSDate *)dateStrConverDate:(NSString *)dateStr dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    return [formatter dateFromString:dateStr];
    
}

//最大左滑到第一次打卡月
//- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
//{
//    return [self.ClockFirstAndLastDate firstObject];
//}
//最大右滑到当前(最新)次打卡月
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
