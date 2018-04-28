//
//  BATHealthThreeSecondsTopChangeDateView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

typedef enum : NSUInteger {
    Yesterday = -1,
    Tomorrow = 1,
    
} Date;

#import "BATHealthThreeSecondsTopChangeDateView.h"
@interface BATHealthThreeSecondsTopChangeDateView ()
@property (nonatomic, strong) NSString *todayStr;
@end
@implementation BATHealthThreeSecondsTopChangeDateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.leftButton];
        [self addSubview:self.centerButton];
        [self addSubview:self.rightButton];
        self.todayStr = [self getToday];
        [self.centerButton setTitle:[NSString stringWithFormat:@"%@(今天)",self.todayStr] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)setDefauDateStr:(NSString *)defauDateStr{
    _defauDateStr = defauDateStr;
    [self setCenterButtonWithDate:defauDateStr];
}

- (void)setCenterButtonWithDate:(NSString *)dateStr{
    
    BOOL isTody =  [dateStr isEqualToString:self.todayStr];
    self.rightButton.enabled = !isTody;
    NSString *formatStr = isTody ? [NSString stringWithFormat:@"%@(今天)",dateStr] : dateStr;
    [self.centerButton setTitle:[NSString stringWithFormat:@"%@",formatStr] forState:UIControlStateNormal];
    
}

- (void)leftButtonClick:(UIButton *)leftButton {
    
    NSString *yesterday = [self formatDate:self.centerButton.titleLabel.text addOrSub:Yesterday];
    
    [self setCenterButtonWithDate:yesterday];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonDidClick:date:)]) {
        [self.delegate leftButtonDidClick:leftButton date:yesterday];
    }
    
    
}
- (void)rightButtonClick:(UIButton *)rightButton{
    
    
    NSString *tomorrow = [self formatDate:self.centerButton.titleLabel.text addOrSub:Tomorrow];
    [self setCenterButtonWithDate:tomorrow];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonDidClick:date:)]) {
        [self.delegate leftButtonDidClick:rightButton date:tomorrow];
    }
    
}

- (void)centerButtonClick:(UIButton *)centerButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerButtonDidClick:callBackBlock:)]) {
        
        [self.delegate centerButtonDidClick:centerButton callBackBlock:^(NSString *date) {
            
            [self setCenterButtonWithDate:date];
            
        }];
        
        
    }
}

/**
 格式化日期
 */
- (NSString *)formatDate:(NSString *)dateStr addOrSub:(NSInteger )flag{
    
    if ([dateStr containsString:@"今天"]) {
        dateStr = [dateStr substringToIndex:10];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSDate *newDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * flag) sinceDate:date];
    NSString *dateFormat =  [formatter stringFromDate:newDate];
    
    return dateFormat;
    
    
}

- (NSString *)getToday{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return  [formatter stringFromDate:date];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(self.centerButton.mas_left);
        make.top.bottom.mas_equalTo(self.centerButton);
        make.width.equalTo(@50);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.centerButton.mas_right);
        make.top.bottom.mas_equalTo(self.centerButton);
        make.width.equalTo(@50);
    }];
    
   
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
//        _leftButton.backgroundColor = batRandomColor;
        [_leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftButton;
}
- (UIButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[UIButton alloc]init];
//        _centerButton.backgroundColor = batRandomColor;
        [_centerButton setTitleColor:UIColorFromHEX(0x666666, 1) forState:UIControlStateNormal];
        _centerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_centerButton setTitle:[NSString stringWithFormat:@"%@",[self getToday]] forState:UIControlStateNormal];
        [_centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _centerButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
//        _rightButton.backgroundColor = batRandomColor;
        [_rightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"disable_right_ arrow"] forState:UIControlStateDisabled];
        
        _rightButton.enabled = NO;
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightButton;
}


@end
