//
//  BATAddProgramSelectTimeView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddProgramSelectTimeView.h"

@implementation BATAddProgramSelectTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.pickerView];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    
    WEAK_SELF(self);
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(85);
        make.left.right.equalTo(self);
        make.height.mas_offset(256);
    }];
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
    }
    return _pickerView;
}

- (UILabel *)hourLabel
{
    if (_hourLabel == nil) {
        
        if (iPhone6p) {
            _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(173, 193, 50, 50)];
        } else if (iPhone6) {
            _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(153, 193, 50, 50)];
        } else if (iPhone4 || iPhone5) {
            _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 193, 50, 50)];
        }
        
        _hourLabel.font = [UIFont systemFontOfSize:10.5];
        _hourLabel.textColor = UIColorFromHEX(0x333333, 1);
        _hourLabel.text = @"时";
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel
{
    if (_minuteLabel == nil) {
        
        if (iPhoneX) {
            _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(278, 193, 50, 50)];
        } else if (iPhone6p) {
            _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(278, 193, 50, 50)];
        } else if (iPhone6) {
            _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(258, 193, 50, 50)];
        } else if (iPhone4 || iPhone5) {
            _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 193, 50, 50)];
        }
        
        _minuteLabel.font = [UIFont systemFontOfSize:10.5];
        _minuteLabel.textColor = UIColorFromHEX(0x333333, 1);
        _minuteLabel.text = @"分";
    }
    return _minuteLabel;
}

@end
