//
//  BATDrugOrderLogisticsDetailView.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderInfoView.h"

@interface BATDrugOrderInfoView ()

{
    CGFloat _commentRangeFont;//小屏幕字太大了
}

@end

@implementation BATDrugOrderInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self layout];
    }
    return self;
}


- (void)contentViewReload{
    
    
}

- (void)layout{
    WEAK_SELF(self);
    
    if(iPhone5){
        _commentRangeFont = 4;
    }else if(iPhone6){
        _commentRangeFont = 2;
    }else{
        _commentRangeFont = 0;
    }
    
    //患者信息
    [self addSubview:self.userMesTitleLabel];
    [self.userMesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    //分割线
    UIView *userLine = [[UIView alloc]initWithFrame:CGRectZero];
    userLine.backgroundColor = BASE_BACKGROUND_COLOR;
    [self addSubview:userLine];
    [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.userMesTitleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(userLine.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [self addSubview:self.birthdayLabel];
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [self addSubview:self.sexLabel];
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(userLine.mas_bottom).offset(10);
        make.left.equalTo(self.mas_centerX).offset(5);
    }];
    
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mas_centerX).offset(5);
    }];
    
    //分割段
    UIView *userView = [[UIView alloc]init];
    userView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(10);
    }];
//    
//    //诊断信息
//    [self addSubview:self.consultMesTitleLabel];
//    [self.consultMesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(userView.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(10);
//    }];
//    
//    //分割线
//    UIView *consultLine = [[UIView alloc]initWithFrame:CGRectZero];
//    consultLine.backgroundColor = BASE_BACKGROUND_COLOR;
//    [self addSubview:consultLine];
//    [consultLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.top.equalTo(self.consultMesTitleLabel.mas_bottom).offset(10);
//        make.height.mas_equalTo(1);
//    }];
//    
//    
//    [self addSubview:self.symptomsLabel];
//    [self.symptomsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(consultLine.mas_bottom).offset(10);
//        make.left.equalTo(self.mas_left).offset(10);
//    }];
//    
//    //分割段
//    UIView *consultView = [[UIView alloc]init];
//    consultView.backgroundColor = BASE_BACKGROUND_COLOR;
//    [self addSubview:consultView];
//    [consultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(self.symptomsLabel.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.height.mas_equalTo(10);
//    }];
//    
//    [self addSubview:self.rpMesTitleLabel];
//    [self.rpMesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(consultView.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(10);
//    }];
//    
//    //分割线
//    UIView *rpLine = [[UIView alloc]init];
//    rpLine.backgroundColor = BASE_BACKGROUND_COLOR;
//    [self addSubview:rpLine];
//    [rpLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(self.rpMesTitleLabel.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.height.mas_equalTo(1);
//    }];
//    
//    [self addSubview:self.rpLabel];
//    [self.rpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(rpLine.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(10);
//    }];
//    
//    //分割段
//    UIView *rpView = [[UIView alloc]init];
//    rpView.backgroundColor = BASE_BACKGROUND_COLOR;
//    [self addSubview:rpView];
//    [rpView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(self.rpLabel.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.height.mas_equalTo(10);
//    }];
//    
//    //医生信息
//    [self addSubview:self.doctorTitleLabel];
//    [self.doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(rpView.mas_bottom).offset(10);
//        make.left.equalTo(self.mas_left).offset(10);
//    }];
//    
//    //分割段
//    UIView *doctorLine = [[UIView alloc]init];
//    doctorLine.backgroundColor = BASE_BACKGROUND_COLOR;
//    [self addSubview:doctorLine];
//    [doctorLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        STRONG_SELF(self);
//        make.top.equalTo(self.doctorTitleLabel.mas_bottom).offset(15);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.height.mas_equalTo(1);
//    }];
//    
//    [self addSubview:self.doctorInfoLabel];
//    [self.doctorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(doctorLine.mas_bottom).offset(10);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//    }];
}

- (UILabel *)userMesTitleLabel{
    
    if (_userMesTitleLabel == nil) {
        _userMesTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _userMesTitleLabel.text = @"患者信息";
        _userMesTitleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _userMesTitleLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
        _userMesTitleLabel.textAlignment = NSTextAlignmentLeft;
        [_userMesTitleLabel sizeToFit];
    }
    return _userMesTitleLabel;
}
- (UILabel *)nameLabel{
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.text = @"姓名：王**";
        _nameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _nameLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_nameLabel sizeToFit];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromHEX(0x999999, 1)
                        range:NSMakeRange(0, 3)];
        _nameLabel.attributedText = attrStr;
    }
    return _nameLabel;
}

- (UILabel *)sexLabel{
    
    if (_sexLabel == nil) {
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _sexLabel.text = @"性别：男";
        _sexLabel.textColor = UIColorFromHEX(0x333333, 1);
        _sexLabel.font = [UIFont systemFontOfSize:17 - _commentRangeFont];
        _sexLabel.textAlignment = NSTextAlignmentLeft;
        [_sexLabel sizeToFit];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_sexLabel.text];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromHEX(0x999999, 1)
                        range:NSMakeRange(0, 3)];
        _sexLabel.attributedText = attrStr;
    }
    return _sexLabel;
}

- (UILabel *)birthdayLabel{
    
    if (_birthdayLabel == nil) {
        _birthdayLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _birthdayLabel.text = @"生日：2017-12-13";
        _birthdayLabel.textColor = UIColorFromHEX(0x333333, 1);
        _birthdayLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
        _birthdayLabel.textAlignment = NSTextAlignmentLeft;
        [_birthdayLabel sizeToFit];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_birthdayLabel.text];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromHEX(0x999999, 1)
                        range:NSMakeRange(0, 3)];
        _birthdayLabel.attributedText = attrStr;
    }
    return _birthdayLabel;
}


- (UILabel *)phoneLabel{
    
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _phoneLabel.text = @"联系电话：187****8483";
        _phoneLabel.textColor = UIColorFromHEX(0x333333, 1);
        _phoneLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        [_phoneLabel sizeToFit];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_phoneLabel.text];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromHEX(0x999999, 1)
                        range:NSMakeRange(0, 5)];
        _phoneLabel.attributedText = attrStr;
    }
    return _phoneLabel;
}


//- (UILabel *)consultMesTitleLabel{
//    
//    if (_consultMesTitleLabel == nil) {
//        _consultMesTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _consultMesTitleLabel.text = @"诊断";
//        _consultMesTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _consultMesTitleLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _consultMesTitleLabel.textAlignment = NSTextAlignmentLeft;
//        [_consultMesTitleLabel sizeToFit];
//    }
//    return _consultMesTitleLabel;
//}
//
//- (UILabel *)symptomsLabel{
//    
//    if (_symptomsLabel == nil) {
//        _symptomsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _symptomsLabel.text = [NSString stringWithFormat:@"%@\n%@",@"热度闭肺症",@"韭子"];
//        _symptomsLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _symptomsLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _symptomsLabel.textAlignment = NSTextAlignmentLeft;
//        [_symptomsLabel sizeToFit];
//    }
//    return _symptomsLabel;
//}
//
//- (UILabel *)rpLabel{
//    
//    if (_rpLabel == nil) {
//        _rpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _rpLabel.text = @"艾叶\n瓦楞子\n韭菜子";
//        _rpLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _rpLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _rpLabel.textAlignment = NSTextAlignmentLeft;
//        [_rpLabel sizeToFit];
//    }
//    return _rpLabel;
//}
//
//- (UILabel *)rpMesTitleLabel{
//    
//    if (_rpMesTitleLabel == nil) {
//        _rpMesTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _rpMesTitleLabel.text = @"RP";
//        _rpMesTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _rpMesTitleLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _rpMesTitleLabel.textAlignment = NSTextAlignmentLeft;
//        [_rpMesTitleLabel sizeToFit];
//    }
//    return _rpMesTitleLabel;
//}
//
//- (UILabel *)doctorTitleLabel{
//    
//    if (_doctorTitleLabel == nil) {
//        _doctorTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _doctorTitleLabel.text = @"看诊医生";
//        _doctorTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _doctorTitleLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _doctorTitleLabel.textAlignment = NSTextAlignmentLeft;
//        [_doctorTitleLabel sizeToFit];
//    }
//    return _doctorTitleLabel;
//}
//- (UILabel *)doctorInfoLabel{
//    
//    if (_doctorInfoLabel == nil) {
//        _doctorInfoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _doctorInfoLabel.text = @"康美医院  全科  健康云 2017-11-24";
//        _doctorInfoLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _doctorInfoLabel.font = [UIFont systemFontOfSize:17- _commentRangeFont];
//        _doctorInfoLabel.textAlignment = NSTextAlignmentLeft;
//        [_doctorInfoLabel sizeToFit];
//    }
//    return _doctorInfoLabel;
//}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end

