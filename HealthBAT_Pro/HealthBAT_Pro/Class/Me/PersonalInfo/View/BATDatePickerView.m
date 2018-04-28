//
//  BATDatePickerView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDatePickerView.h"
#import "UIView+Extension.h"
typedef void(^ToolBarActionBlock)(void);
@interface BATDatePickerToolBar : UIView
@property (nonatomic ,strong) UIButton              *sureBtn;
@property (nonatomic ,strong) UIButton              *cancelBtn;
@property (nonatomic ,strong) UILabel               *textLabel;
@property (nonatomic ,strong) UIView                *lineV;
@property (nonatomic ,copy)   ToolBarActionBlock    cancelAction;
@property (nonatomic ,copy)   ToolBarActionBlock    sureAction;
- (instancetype)initWithToolbarText:(NSString *)toolBarText cancelAction:(ToolBarActionBlock)cancelAction sureAction:(ToolBarActionBlock)sureAction;
@end

@implementation BATDatePickerToolBar
- (instancetype)initWithToolbarText:(NSString *)toolBarText cancelAction:(ToolBarActionBlock)cancelAction sureAction:(ToolBarActionBlock)sureAction {
    if (self = [super init]) {
        self.cancelAction = [cancelAction copy];
        self.sureAction = [sureAction copy];
        self.textLabel.text = toolBarText;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.textLabel];
    [self addSubview:self.lineV];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10.0;
    CGFloat lineVHeight = 1.0;
    CGFloat widthBtn = 44.0;
    CGFloat heightBtn = self.height - lineVHeight;
    self.cancelBtn.frame = CGRectMake(padding, 0, widthBtn, heightBtn);
    self.sureBtn.frame = CGRectMake(self.width-padding-widthBtn, 0, widthBtn, heightBtn);
    self.textLabel.frame = CGRectMake(self.cancelBtn.right+padding, 0, self.width-self.cancelBtn.right-2*padding-widthBtn, heightBtn);
    self.lineV.frame = CGRectMake(0, heightBtn, self.width, lineVHeight);
}

#pragma mark -- pravite
- (void)sureBtnByClick:(UIButton *)sender {
    if (self.sureAction) {
        self.sureAction();
    }
}

- (void)cancelBtnByClick:(UIButton *)sender {
    if (self.cancelAction) {
        self.cancelAction();
    }
}
#pragma mark -- setter & getter
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorFromRGB(24, 128, 250, 1) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_sureBtn addTarget:self action:@selector(sureBtnByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(24, 128, 250, 1) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_cancelBtn addTarget:self action:@selector(cancelBtnByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _textLabel;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineV;
}
@end


@interface BATDatePickerView ()

@property (nonatomic ,copy)   NSString                    *dateString;
@property (nonatomic ,copy)   NSString                    *selectDate;
@property (nonatomic ,strong) BATDatePickerToolBar        *dateToolBar;
@property (nonatomic ,strong) UIDatePicker                *datePicker;
@property (nonatomic ,strong) NSDateFormatter             *dateFormatter;
@end

@implementation BATDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.dateToolBar = [[BATDatePickerToolBar alloc] initWithToolbarText:@"" cancelAction:^{
        [self hide];
    } sureAction:^{
        [self hide];
        if (self.delegate && [self.delegate respondsToSelector:@selector(batDatePickerView:didSelectDate:)]) {
            [self.delegate batDatePickerView:self didSelectDate:self.selectDate];
        }
    }];
    [self addSubview:self.dateToolBar];
    [self addSubview:self.datePicker];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dateToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.dateToolBar.mas_bottom);
    }];
}

#pragma mark private
- (void)setupSelectedValueDidChange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(batDatePickerView:selectDateValueChange:)]) {
        [self.delegate batDatePickerView:self selectDateValueChange:self.selectDate];
    }
}

- (NSDate *)formatterStringToDate:(NSString *)string {
    return [self.dateFormatter dateFromString:string];
}

- (NSString *)formatterDateToString:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)divisionByBlankSpace:(NSString *)string {
    return [[string componentsSeparatedByString:@" "] firstObject];
}
#pragma mark Action
- (void)showWithBirthday:(NSString *)birthday {
    self.datePicker.date = [self formatterStringToDate:[self divisionByBlankSpace:birthday]];
    self.selectDate = [self formatterDateToString:self.datePicker.date];;
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    self.selectDate = [self formatterDateToString:datePicker.date];
    [self setupSelectedValueDidChange];
}

#pragma mark set & get
//- (void)setSelectDate:(NSString *)selectDate {
//    _selectDate = selectDate;
//    self.datePicker.date = [self formatterStringToDate:selectDate];
//}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
//        self.selectDate = [self formatterDateToString:_datePicker.date];
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}
@end
