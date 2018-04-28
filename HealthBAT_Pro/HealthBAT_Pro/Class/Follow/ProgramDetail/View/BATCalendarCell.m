//
//  BATCalendarCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCalendarCell.h"
#import "UIColor+Gradient.h"
#import "FSCalendar.h"

@interface BATCalendarCell ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation BATCalendarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self commmonInit];
        
    }
    return self;
}

- (void)commmonInit{
    
    _dateFormatter=[[NSDateFormatter alloc]init];
    _dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    FSCalendar *calendar = [[FSCalendar alloc] init];
    calendar.dataSource = self;
    calendar.delegate = self;
    //设置为中文
    //    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    calendar.locale = locale;
    //自己设置字体
    self.calendar = calendar;
    
    //是都可以多选
    calendar.allowsMultipleSelection = YES;
    calendar.pagingEnabled = YES;
    //取消下个月或上个月的日期显示
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.weekdayTextColor = UIColorFromHEX(0x666666, 1);
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:12];
    calendar.appearance.titleDefaultColor = UIColorFromHEX(0x666666, 1);
    calendar.appearance.headerTitleColor = UIColorFromHEX(0x333333, 1);
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.today = nil; //隐藏当天
//    calendar.appearance.eventDefaultColor = [UIColor redColor];
    calendar.appearance.eventSelectionColor = [UIColor yellowColor];
    calendar.appearance.selectionColor = [UIColor yellowColor];
    //设置底部显示日期格式
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    
    
   
    [self.contentView addSubview:calendar];
    
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

//禁止点击选中日期

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{

    return NO;
}
//禁止取消点击选中日期
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{

    return NO;
}
//最大左滑到第一次打卡月
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.ClockFirstAndLastDate firstObject];
}
//最大右滑到当前(最新)次打卡月
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.ClockFirstAndLastDate lastObject];
}

//设置选中文字颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    return [UIColor whiteColor];
}

//设置选中背景色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    return [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:calendar.rowHeight];
}


//设置选中的日期
- (void)setDatesSelected:(NSMutableArray *)datesSelected{
    _datesSelected = datesSelected;
    
    for (NSDate *date in datesSelected) {
        [self.calendar selectDate:date];
        
    }
    
    [self.calendar reloadData];
    
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    
}

//设置最大左右滑动的范围
- (void)setClockFirstAndLastDate:(NSMutableArray *)ClockFirstAndLastDate{
    _ClockFirstAndLastDate = ClockFirstAndLastDate;
    self.calendar.scrollEnabled = ClockFirstAndLastDate.count;
    
    [self.calendar reloadData];
}



@end

