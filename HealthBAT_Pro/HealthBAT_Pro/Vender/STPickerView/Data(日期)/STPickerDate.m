//
//  STPickerDate.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerDate.h"
#import "NSCalendar+STPicker.h"
@interface STPickerDate()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;

@end

@implementation STPickerDate

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择日期";
    
//    _yearLeast = 1900;
    _yearSum   = [NSCalendar currentYear]-1899;
    _heightPickerComponent = 28;
    
    _yearMax = [NSCalendar currentYear];
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearSum;
    }else if(component == 1) {
        
        if (self.yearMax - [pickerView selectedRowInComponent:0] == [NSCalendar currentYear]) {
            //currentYear
            return [NSCalendar currentMonth];
        }
        
        return 12;
    }else {
        
        if (self.yearMax - [pickerView selectedRowInComponent:0] == [NSCalendar currentYear] && [pickerView selectedRowInComponent:1] + 1 == [NSCalendar currentMonth]) {
            //currentYear currentMonth
            
            return [NSCalendar currentDay];
        }
        NSInteger yearSelected = self.yearMax - [pickerView selectedRowInComponent:0];
        NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
        return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
        default:
            break;
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%zd", -row + self.yearMax];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%zd", row + 1];
    }else{
        text = [NSString stringWithFormat:@"%zd", row + 1];
    }

    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:day:)]) {
         [self.delegate pickerDate:self year:self.year month:self.month day:self.day];
    }
   
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    self.year  = self.yearMax - [self.pickerView selectedRowInComponent:0];
    self.month = [self.pickerView selectedRowInComponent:1] + 1;
    self.day   = [self.pickerView selectedRowInComponent:2] + 1;
}

#pragma mark - --- setters 属性 ---

//- (void)setYearLeast:(NSInteger)yearLeast
//{
//
//    if (yearLeast<=0) {
//        return;
//    }
//
//    _yearLeast = yearLeast;
//    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
//    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
//    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
//    [self.pickerView reloadAllComponents];
//}
- (void)setYearSum:(NSInteger)yearSum{
    if (yearSum<=0) {
        return;
    }
    
    _yearSum = yearSum;
    [self.pickerView reloadAllComponents];
}
#pragma mark - --- getters 属性 ---

#pragma mark -
- (void)selectCustomDate:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *customDate = [calendar components:unitFlags fromDate:date];
    
    _year = customDate.year;
    _month = customDate.month;
    _day = customDate.day;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView selectRow:_yearMax - _year inComponent:0 animated:NO];
        [self.pickerView selectRow:_month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:_day-1 inComponent:2 animated:NO];
        
        [self.pickerView reloadAllComponents];
    });
}


@end


