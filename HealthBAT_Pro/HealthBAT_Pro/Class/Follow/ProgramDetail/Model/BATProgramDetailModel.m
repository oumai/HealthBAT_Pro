//
//  BATProgramDetailModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramDetailModel.h"

@implementation BATProgramDetailModel

@end

@implementation BATProgramDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"ProgrammeLst" : [BATProgramItem class],
             @"PlanLst" : [BATPlanItem class],
             @"ProductList" : [ProductList class],
             @"ClockInList" : [BATClockInItem class],
             @"RelevantSolutionList": [BATRelevantSolutionItem class]};
}


- (NSMutableArray *)ClockInTimeListFormat{
    if (!_ClockInTimeListFormat) {
        _ClockInTimeListFormat = [NSMutableArray array];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
        for (NSDictionary *dateDict in self.ClockInTimeList) {
            NSString *dateStr = [dateDict objectForKey:@"ClockedTime"];
            NSDate *date = [dateFormatter dateFromString:dateStr];
            [_ClockInTimeListFormat addObject:date];
        }
        
        
    }
    
    return _ClockInTimeListFormat;
}

- (NSMutableArray *)ClockFirstAndLastDate{
    if (!_ClockFirstAndLastDate) {
        _ClockFirstAndLastDate = [NSMutableArray array];
        
        if (self.ClockInTimeList.count) {
            NSDateFormatter *dateFormatterM=[[NSDateFormatter alloc]init];
            dateFormatterM.dateFormat=@"yyyy-MM-dd HH:mm:ss";
           //当前月第一次打卡日期
            NSString *firstClockDateStr = [[self.ClockInTimeList firstObject] objectForKey:@"ClockedTime"];
           //获取当前时间
            NSString *currentDateStr = [dateFormatterM stringFromDate:[NSDate date]];
            
            //获取首次打卡月的第一天
            firstClockDateStr =  [self getMonthFirstAndLastDayWith:firstClockDateStr].firstObject;
            //获取当前月的最后一天
            currentDateStr = [self getMonthFirstAndLastDayWith:currentDateStr].lastObject;
            
            NSDate *startDate = [dateFormatterM dateFromString:firstClockDateStr];
            NSDate *endDate = [dateFormatterM dateFromString:currentDateStr];
            
            [_ClockFirstAndLastDate addObject:startDate];
            [_ClockFirstAndLastDate addObject:endDate];
            
        }
    }
    
    return _ClockFirstAndLastDate;
}
- (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [format stringFromDate: firstDate];
    NSString *lastString = [format stringFromDate: lastDate];
    return @[firstString, lastString];
}

@end

@implementation ProductList



@end

@implementation BATProgramItem


@end

@implementation BATPlanItem



@end

@implementation BATClockInItem



@end

@implementation BATRelevantSolutionItem



@end
