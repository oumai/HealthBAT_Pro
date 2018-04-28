//
//  BATAlertOrderInfoView.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlertOrderInfoView.h"

@implementation BATAlertOrderInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.bigBGView];
        [self.bigBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        [self.bigBGView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.centerY.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH - 40);
            make.height.mas_equalTo(260);
        }];
        
        [self.bgView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@20);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.bgView addSubview:self.buyerTextfiled];
        [self.buyerTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLable.mas_bottom).offset(40);
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.height.equalTo(self.titleLable.mas_height);
        }];
        
        [self.bgView addSubview:self.buyerLine];
        [self.buyerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.buyerTextfiled.mas_bottom).offset(5);
            make.left.equalTo(self.buyerTextfiled.mas_left).offset(70);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self.bgView addSubview:self.phoneTextfiled];
        [self.phoneTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.buyerTextfiled.mas_bottom).offset(23);
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.height.equalTo(self.titleLable.mas_height);
        }];
        
        [self.bgView addSubview:self.phoneLine];
        [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.phoneTextfiled.mas_bottom).offset(5);
            make.left.equalTo(self.buyerTextfiled.mas_left).offset(70);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self.bgView addSubview:self.adressTextfiled];
        [self.adressTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.phoneTextfiled.mas_bottom).offset(23);
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.height.equalTo(self.titleLable.mas_height);
        }];
        
        [self.bgView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.adressTextfiled.mas_bottom).offset(20);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self.bgView addSubview:self.sureButton];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.right.equalTo(self.bgView.mas_right);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self.bgView.mas_bottom);
        }];
        
    }
    return self;
}


- (void)loadFamilyDoctorDetail:(BATFamilyDoctorModel *)familyDoctorDetail{
    
    if (familyDoctorDetail != nil ) {
        
        _buyerTextfiled.text = familyDoctorDetail.Data.TrueName;
        _phoneTextfiled.text = familyDoctorDetail.Data.IDNumber;
        _adressTextfiled.text = familyDoctorDetail.Data.ContactAddress;
    }
    
}


- (UIView *)bigBGView{
    if (!_bigBGView) {
        _bigBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _bigBGView.backgroundColor = UIColorFromHEX(0x000000, 0.3);
        _bigBGView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_bigBGView bk_whenTapped:^{
            STRONG_SELF(self);
            [self endEditing:YES];
            if (self.clickBigBGViewBlock) {
                self.clickBigBGViewBlock();
            }
        }];
    }
    return  _bigBGView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.f;
        _bgView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_bgView bk_whenTapped:^{
            STRONG_SELF(self);
            [self endEditing:YES];
        }];
    }
    return  _bgView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:17] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _titleLable.text = @"填写信息";
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}

- (UITextField *)buyerTextfiled{
    if (!_buyerTextfiled) {
        _buyerTextfiled = [UITextField textFieldWithfont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) placeholder:@"请填写名字" BorderStyle:UITextBorderStyleNone];
//        _buyerTextfiled.backgroundColor = [UIColor blueColor];
        _buyerTextfiled.keyboardType = UIKeyboardTypeDefault;
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        leftLable.text = @"买方：";
        _buyerTextfiled.leftView = leftLable;
        _buyerTextfiled.leftViewMode = UITextFieldViewModeAlways;
        
    }
    
    return _buyerTextfiled;
}


- (UITextField *)phoneTextfiled{
    if (!_phoneTextfiled) {
        _phoneTextfiled = [UITextField textFieldWithfont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) placeholder:@"请填写身份证" BorderStyle:UITextBorderStyleNone];
//        _phoneTextfiled.backgroundColor = [UIColor yellowColor];
        _phoneTextfiled.keyboardType = UIKeyboardTypeDefault;
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        leftLable.text = @"身份证：";
        _phoneTextfiled.leftView = leftLable;
        _phoneTextfiled.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _phoneTextfiled;
}



- (UITextField *)adressTextfiled{
    if (!_adressTextfiled) {
        _adressTextfiled = [UITextField textFieldWithfont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) placeholder:@"请填写地址" BorderStyle:UITextBorderStyleNone];
//        _adressTextfiled.backgroundColor = [UIColor redColor];
        _adressTextfiled.keyboardType = UIKeyboardTypeDefault;
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        leftLable.text = @"地址：";
        _adressTextfiled.leftView = leftLable;
        _adressTextfiled.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _adressTextfiled;
}


- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确认" titleColor:[UIColor blackColor] backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:16]];
        WEAK_SELF(self);
        [_sureButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.sureButtonBlock) {
                self.sureButtonBlock();
            }
        }];
    }
    return _sureButton;
}



- (UIView *)buyerLine{
    if (!_buyerLine) {
        _buyerLine = [[UIView alloc]initWithFrame:CGRectZero];
        _buyerLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _buyerLine;
}


- (UIView *)phoneLine{
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc]initWithFrame:CGRectZero];
        _phoneLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _phoneLine;
}


- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = UIColorFromHEX(0xcccccc, 1);
    }
    
    return _bottomLine;
}

@end
