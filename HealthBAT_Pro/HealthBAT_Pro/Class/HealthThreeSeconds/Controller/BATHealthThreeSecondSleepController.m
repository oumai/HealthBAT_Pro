//
//  BATHealthThreeSecondSleepController.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSleepController.h"
#import "BATBATHealthThreeSecondCircleSlider.h"
#import "BATGraditorButton.h"
#import "GLDateUtils.h"

@interface BATColorButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame backBGColorArray:(NSArray *)colorArray;
@end

@implementation BATColorButton
- (instancetype)initWithFrame:(CGRect)frame backBGColorArray:(NSArray *)colorArray {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[self buttonBackBGColorWith:colorArray] forState:UIControlStateNormal];
    }
    return self;
}

- (UIImage *)buttonBackBGColorWith:(NSArray *)colorArray {
    NSMutableArray *colorArr = [[NSMutableArray alloc] init];
    for (UIColor *color in colorArray) {
        [colorArr addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArray lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colorArr, NULL);
    CGPoint start = CGPointZero;
    CGPoint end = CGPointMake(self.frame.size.width, 0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
@end


@interface BATHealthThreeSecondSleepController ()
@property (nonatomic, weak)   BATBATHealthThreeSecondCircleSlider       *circleSlider;
@property (nonatomic, weak)   UILabel                                   *bedTimeLabel;
@property (nonatomic, weak)   UILabel                                   *wakeTimeLabel;
@property (nonatomic, strong) BATGraditorButton                         *bedTimeButton;
@property (nonatomic, strong) BATGraditorButton                         *wakeTimeButton;
@property (nonatomic, weak)   UILabel                                   *timeLabel;
@property (nonatomic, weak)   UILabel                                   *wakeDateLabel;
@property (nonatomic, strong) NSDateFormatter                           *timeFormatter;//NSDateFormatter实例化很耗性能
@property (nonatomic, strong) NSDateFormatter                           *hourFormatter;
@property (nonatomic, strong) NSDateFormatter                           *minuteFormatter;
@property (nonatomic, strong) BATColorButton                            *sureButton;
@property (nonatomic, strong) NSDate                                    *durationDate;
@property (nonatomic, strong) NSDate                                    *tomorrowDate;
@property (nonatomic, assign) NSTimeInterval                            duration;
@property (nonatomic, copy)   sureButtonBlock                           sureButtonBlock;
@property (nonatomic, copy)   NSString                                  *selectedDate;
@property (nonatomic, copy)   NSString                                  *bedTime;
@property (nonatomic, copy)   NSString                                  *getUpTime;
@end
static CGFloat dayInSeconds = 24 * 60 * 60;
@implementation BATHealthThreeSecondSleepController

- (BOOL)fd_interactivePopDisabled{
    return YES;
}
- (instancetype)initWithSelectedDate:(NSString *)selectedDate bedTime:(NSString *)bedTime getUpTime:(NSString *)getUpTime makeSureComplete:(sureButtonBlock)sureButtonBlock {
    if (self = [super init]) {
        _selectedDate = selectedDate;
        _bedTime = bedTime;
        _getUpTime = getUpTime;
        _sureButtonBlock = sureButtonBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录睡眠时间";
    BATBATHealthThreeSecondCircleSlider *circleSlider = [[BATBATHealthThreeSecondCircleSlider alloc] initWithFrame:CGRectMake((self.view.width-320)/2, 80, 320, 320)];
    circleSlider.backgroundColor = [UIColor clearColor];
    circleSlider.startThumbImage = [UIImage imageNamed:@"bat_healthThreeSec_sleep_start"];
    circleSlider.endThumbImage = [UIImage imageNamed:@"bat_healthThreeSec_sleep_end"];
    circleSlider.maximumValue = dayInSeconds;
    circleSlider.numberOfRounds = 2;
    circleSlider.thumbRadius = 13;
    circleSlider.trackFillColor = UIColorFromRGB(110, 203, 94, 1);
    circleSlider.trackColor = UIColorFromRGB(222, 255, 245, 1);
    circleSlider.lineWidth = 40;
    circleSlider.backtrackLineWidth = 40;
    if ([self.bedTime isEqualToString:@"0001-01-01 00:00:00"]) {
        circleSlider.startPointValue = 22 * 60 * 60;
    } else {
        circleSlider.startPointValue = [self getSecondWith:self.bedTime];
    }
    if ([self.getUpTime isEqualToString:@"0001-01-01 00:00:00"]) {
        circleSlider.endPointValue = 6 * 60 * 60;
    } else {
        circleSlider.endPointValue = [self getSecondWith:self.getUpTime];
    }
    [circleSlider addTarget:self action:@selector(updateTimeLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circleSlider];
    self.circleSlider = circleSlider;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 190)];
    imageView.image = [UIImage imageNamed:@"Hours"];
    imageView.center = self.circleSlider.center;
    [self.view addSubview:imageView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 90)];
    timeLabel.center = imageView.center;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = UIColorFromRGB(85, 210, 181, 1);
    timeLabel.font = [UIFont systemFontOfSize:23.0];
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;

    UILabel *bedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 120, 30)];
    bedDateLabel.textAlignment = NSTextAlignmentCenter;
    bedDateLabel.font = [UIFont systemFontOfSize:17.0];
    bedDateLabel.textColor = UIColorFromRGB(155, 155, 155, 1);
    bedDateLabel.text = self.selectedDate;
    [self.view addSubview:bedDateLabel];
    
    UILabel *wakeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2+40, 10, 120, 30)];
    wakeDateLabel.textAlignment = NSTextAlignmentCenter;
    wakeDateLabel.font = [UIFont systemFontOfSize:17.0];
    wakeDateLabel.textColor = UIColorFromRGB(155, 155, 155, 1);
    [self.view addSubview:wakeDateLabel];
    self.wakeDateLabel = wakeDateLabel;
    
    UILabel *bedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 100, 30)];
    bedTimeLabel.textAlignment = NSTextAlignmentLeft;
    bedTimeLabel.font = [UIFont systemFontOfSize:19.0];
    [self.view addSubview:bedTimeLabel];
    self.bedTimeLabel = bedTimeLabel;

    UILabel *wakeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2+100, 40, 100, 30)];
    wakeTimeLabel.textAlignment = NSTextAlignmentLeft;
    wakeTimeLabel.font = [UIFont systemFontOfSize:19.0];
    [self.view addSubview:wakeTimeLabel];
    self.wakeTimeLabel = wakeTimeLabel;
    
    [self.view addSubview:self.bedTimeButton];
    [self.view addSubview:self.wakeTimeButton];
    [self.view addSubview:self.sureButton];
    [self updateTimeLabel:self.circleSlider];
}

- (void)updateTimeLabel:(BATBATHealthThreeSecondCircleSlider *)circleSlider {
    circleSlider.startPointValue = [self adjustValue:circleSlider.startPointValue];
    circleSlider.endPointValue = [self adjustValue:circleSlider.endPointValue];
    NSTimeInterval bedTime = (NSTimeInterval)circleSlider.startPointValue;
    NSDate *bedTimeDate = [NSDate dateWithTimeIntervalSinceReferenceDate:bedTime];
    self.bedTimeLabel.text = [NSString stringWithFormat:@"%@",[self.timeFormatter stringFromDate:bedTimeDate]];
    NSTimeInterval wakeTime = (NSTimeInterval)circleSlider.endPointValue;
    NSDate *wakeDate = [NSDate dateWithTimeIntervalSinceReferenceDate:wakeTime];
    self.wakeTimeLabel.text = [NSString stringWithFormat:@"%@",[self.timeFormatter stringFromDate:wakeDate]];
    
    NSTimeInterval duration = wakeTime - bedTime;
    self.duration = duration;
    if (self.duration <= 0.0) {
        self.wakeDateLabel.text = [self formatDateWith:self.selectedDate];
    } else {
        self.wakeDateLabel.text = self.selectedDate;
    }
    if (wakeTime == dayInSeconds) {
        self.wakeDateLabel.text = [self formatDateWith:self.selectedDate];
    }
    if (bedTime == dayInSeconds) {
        self.wakeDateLabel.text = self.selectedDate;
    }
    self.durationDate = self.duration == 0 ? self.tomorrowDate : [NSDate dateWithTimeIntervalSinceReferenceDate:duration];
    self.timeLabel.text = [self.timeFormatter stringFromDate:self.durationDate];
    NSString *timeStr = [NSString stringWithFormat:@"%@hr %@min",[self.hourFormatter stringFromDate:self.durationDate],[self.minuteFormatter stringFromDate:self.durationDate]];
    self.timeLabel.text = (duration == 0 ? @"24hr 0min" : timeStr);
}

- (void)sureButtonByClick:(UIButton *)sender {
    NSString *getUpTimeStr = nil;
    NSString *hour = nil;
    if (self.duration < 0.0) {
        getUpTimeStr = [NSString stringWithFormat:@"%@ %@",[self formatDateWith:self.selectedDate],self.wakeTimeLabel.text];
        CGFloat minute = [[self.minuteFormatter stringFromDate:self.durationDate] floatValue]/60.0*10;
        hour = [NSString stringWithFormat:@"%@.%ld",[self.hourFormatter stringFromDate:self.durationDate],(unsigned long)minute];
    } else if (self.duration == 0) {
        getUpTimeStr = [NSString stringWithFormat:@"%@ %@",[self formatDateWith:self.selectedDate],self.wakeTimeLabel.text];
        hour = @"24.00";
    } else {
        getUpTimeStr = self.wakeTimeLabel.text;
        CGFloat minute = [[self.minuteFormatter stringFromDate:self.durationDate] floatValue]/60.0*10;
        hour = [NSString stringWithFormat:@"%@.%ld",[self.hourFormatter stringFromDate:self.durationDate],(unsigned long)minute];
    }
    if (self.sureButtonBlock) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict jk_setObj:hour forKey:@"SleepHours"];
        [dict jk_setObj:self.bedTimeLabel.text forKey:@"BedTime"];
        [dict jk_setObj:getUpTimeStr forKey:@"GetUpTime"];
        self.sureButtonBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)adjustValue:(CGFloat)value {
    CGFloat minutes = value/60;
    CGFloat adjustedMinutes = ceil(minutes/1.0)*1;
    return adjustedMinutes*60;
}

//获取年月日时分秒
- (CGFloat)getSecondWith:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [dateCom hour];
    NSInteger minute = [dateCom minute];
    NSInteger second = [dateCom second];
    NSInteger total = hour*60*60 + minute*60 + second;
    return (CGFloat)total;
}

- (NSString *)formatDateWith:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    self.tomorrowDate = [GLDateUtils dateByAddingDays:1 toDate:date];
    return [formatter stringFromDate:self.tomorrowDate];
}

#pragma mark -- setter & getter
- (NSDateFormatter *)hourFormatter {
    if (!_hourFormatter) {
        _hourFormatter = [[NSDateFormatter alloc] init];
        _hourFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        _hourFormatter.dateFormat = @"H";
    }
    return _hourFormatter;
}

- (NSDateFormatter *)minuteFormatter {
    if (!_minuteFormatter) {
        _minuteFormatter = [[NSDateFormatter alloc] init];
        _minuteFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        _minuteFormatter.dateFormat = @"m";
    }
    return _minuteFormatter;
}

- (NSDateFormatter *)timeFormatter {
    if (!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        _timeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        _timeFormatter.dateFormat = @"HH:mm";
    }
    return _timeFormatter;
}

- (BATColorButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[BATColorButton alloc] initWithFrame:CGRectMake(20, 420, SCREEN_WIDTH-20*2, 40) backBGColorArray:@[START_COLOR,END_COLOR]];
        _sureButton.layer.cornerRadius = 20;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (BATGraditorButton *)bedTimeButton {
    if (!_bedTimeButton) {
        _bedTimeButton = [[BATGraditorButton alloc] initWithFrame:CGRectMake(40, 40, 60, 30)];
        _bedTimeButton.enbleGraditor = YES;
        _bedTimeButton.userInteractionEnabled = NO;
        _bedTimeButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_bedTimeButton setGradientColors:@[START_COLOR,END_COLOR]];
        [_bedTimeButton setTitle:@"就寝:" forState:UIControlStateNormal];
    }
    return _bedTimeButton;
}

- (BATGraditorButton *)wakeTimeButton {
    if (!_wakeTimeButton) {
        _wakeTimeButton = [[BATGraditorButton alloc] initWithFrame:CGRectMake(self.view.width/2+40, 40, 60, 30)];
        _wakeTimeButton.enbleGraditor = YES;
        _wakeTimeButton.userInteractionEnabled = NO;
        _wakeTimeButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_wakeTimeButton setGradientColors:@[START_COLOR,END_COLOR]];
        [_wakeTimeButton setTitle:@"起床:" forState:UIControlStateNormal];
    }
    return _wakeTimeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

