//
//  BATFamilyDoctorOrderDetailNumberView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderDetailNumberView.h"

@implementation BATFamilyDoctorOrderDetailNumberView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self pageLayouts];
    }
    return self;
}

- (void)pageLayouts{
    
    WEAK_SELF(self);
    [self addSubview:self.leftLine];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(@27.5);
        make.left.equalTo(self);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.mas_centerX);
    }];
    
    [self addSubview:self.rightLine];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(@27.5);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.mas_centerX);
    }];
    
    [self addSubview:self.numberView];
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(@12.5);
        make.centerX.equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(30);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.numberView.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.left.right.equalTo(self);
    }];
}



- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = UIColorFromHEX(0xd5d4d4, 1);
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc]init];
        _rightLine.backgroundColor = UIColorFromHEX(0xd5d4d4, 1);
    }
    return _rightLine;
}

- (UIImageView *)numberView{
    if (!_numberView) {
        _numberView = [[UIImageView alloc] init];
    }
    return _numberView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}


@end
