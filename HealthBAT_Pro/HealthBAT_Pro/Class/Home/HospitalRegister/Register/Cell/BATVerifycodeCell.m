//
//  BATVerifycodeCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/4.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATVerifycodeCell.h"
#import "BATGraditorButton.h"
@interface BATVerifycodeCell()

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) BATGraditorButton *verifyBtn;
@end
@implementation BATVerifycodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        [self.contentView addSubview:self.eventLabel];
        [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(13);
            make.top.equalTo(self.contentView.mas_top).offset(16);
        }];
        
        [self.contentView addSubview:self.infotextfiled];
        [self.infotextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(13);
            make.top.equalTo(self.eventLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(200);
        }];
        
        [self.contentView addSubview:self.verifyBtn];
        [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.centerY.equalTo(self.infotextfiled.mas_centerY);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.left.equalTo(self.contentView.mas_left).offset(13);
            make.right.equalTo(self.contentView.mas_right).offset(14);
            make.top.equalTo(self.verifyBtn.mas_bottom).offset(7.5);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}
#pragma mark Action
-(void)getVerifyCode:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BATVerifycodeCellGetVerifyCodeWithBtn:)]) {
        [self.delegate BATVerifycodeCellGetVerifyCodeWithBtn:sender];
    }
}

#pragma mark -SETTER - GETTER
- (UILabel *)eventLabel {
    if (!_eventLabel) {
        _eventLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _eventLabel;
}

- (UITextField *)infotextfiled {
    if (!_infotextfiled) {
        _infotextfiled = [[UITextField alloc]init];
        _infotextfiled.placeholder = @"请输入手机验证码";
        _infotextfiled.font = [UIFont systemFontOfSize:15];
        _infotextfiled.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _infotextfiled;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}

-(BATGraditorButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn = [[BATGraditorButton alloc]init];
        _verifyBtn.clipsToBounds = YES;
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _verifyBtn.layer.cornerRadius = 5;
        [_verifyBtn addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}

@end
