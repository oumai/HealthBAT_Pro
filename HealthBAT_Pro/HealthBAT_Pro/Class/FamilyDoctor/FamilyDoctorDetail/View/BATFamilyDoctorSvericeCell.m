//
//  BATFamilyDoctorSvericeCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorSvericeCell.h"

@implementation BATFamilyDoctorSvericeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(45.f);
        }];
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.topLine];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.bgView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
        }];
        
        
        [self.contentView addSubview:self.oneMothButton];
        [self.oneMothButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.bgView.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(20);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(34);
        }];
        
        [self.contentView addSubview:self.threeMothButton];
        [self.threeMothButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.bgView.mas_bottom).offset(10);
            if(iPhone5){
                 make.left.equalTo(self.oneMothButton.mas_right).offset(10);
            }else{
                make.left.equalTo(self.oneMothButton.mas_right).offset(30);
            }
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(34);
        }];
        
        [self.contentView addSubview:self.sixMothButton];
        [self.sixMothButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.oneMothButton.mas_left);
            make.top.equalTo(self.oneMothButton.mas_bottom).offset(15);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(34);
        }];
        
        [self.contentView addSubview:self.twelveMothButton];
        [self.twelveMothButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.threeMothButton.mas_bottom).offset(15);
            if(iPhone5){
                make.left.equalTo(self.sixMothButton.mas_right).offset(10);
            }else{
                make.left.equalTo(self.sixMothButton.mas_right).offset(30);
            }
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(34);
        }];
        
        [self.contentView addSubview:self.bottoBGmView];
        [self.bottoBGmView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.sixMothButton.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(10);
        }];
        
        [self.contentView addSubview:self.dateBGmView];
        [self.dateBGmView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.bottoBGmView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.dateBGmView.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            [self.dateLabel sizeToFit];
        }];
        
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.dateLabel.mas_centerY);
            make.left.equalTo(self.dateLabel.mas_right).offset(10);
            [self.timeLabel sizeToFit];
        }];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
            make.bottom.equalTo(@-0.5f);
        }];
        
        
        [self.contentView addSubview:self.oneMButton];
        [self.oneMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.oneMothButton);
        }];
        
        [self.contentView addSubview:self.threeMButton];
        [self.threeMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.threeMothButton);
        }];
        
        [self.contentView addSubview:self.sixMButton];
        [self.sixMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.sixMothButton);
        }];
        
        [self.contentView addSubview:self.twelveMButton];
        [self.twelveMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.twelveMothButton);
        }];
    }
    return self;
}

#pragma mark - 改变按钮选择
#pragma mark - 改变该显示的渐变btn
- (void)changeOtherButtonStation:(NSInteger )tag{
    
    switch (tag) {
        case 2001:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMButton.hidden = NO;
            self.threeMButton.hidden = YES;
            self.sixMButton.hidden = YES;
            self.twelveMButton.hidden = YES;
            
//            _oneMothButton.selected = YES;
//            _threeMothButton.selected = NO;
//            _sixMothButton.selected = NO;
//            _twelveMothButton.selected = NO;
//            _oneMothButton.layer.borderColor = UIColorFromHEX(0x0182eb, 1).CGColor;
//            _threeMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _sixMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _twelveMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        }
            break;
        case 2003:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMButton.hidden = YES;
            self.threeMButton.hidden = NO;
            self.sixMButton.hidden = YES;
            self.twelveMButton.hidden = YES;
            
//            _oneMothButton.selected = NO;
//            _threeMothButton.selected = YES;
//            _sixMothButton.selected = NO;
//            _twelveMothButton.selected = NO;
//            _oneMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _threeMothButton.layer.borderColor = UIColorFromHEX(0x0182eb, 1).CGColor;
//            _sixMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _twelveMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        }
            break;
        case 2006:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMButton.hidden = YES;
            self.threeMButton.hidden = YES;
            self.sixMButton.hidden = NO;
            self.twelveMButton.hidden = YES;
            
//            _oneMothButton.selected = NO;
//            _threeMothButton.selected = NO;
//            _sixMothButton.selected = YES;
//            _twelveMothButton.selected = NO;
//            _oneMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _threeMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _sixMothButton.layer.borderColor = UIColorFromHEX(0x0182eb, 1).CGColor;
//            _twelveMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        }
            break;
        case 2012:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMButton.hidden = YES;
            self.threeMButton.hidden = YES;
            self.sixMButton.hidden = YES;
            self.twelveMButton.hidden = NO;
            
//            _oneMothButton.selected = NO;
//            _threeMothButton.selected = NO;
//            _sixMothButton.selected = NO;
//            _twelveMothButton.selected = YES;
//            _oneMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _threeMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _sixMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
//            _twelveMothButton.layer.borderColor = UIColorFromHEX(0x0182eb, 1).CGColor;
        }
            break;
            
        default:
            break;
    }
}


- (void)setCellWithModel:(BATFamilyDoctorModel *)familyDoctorModel{

    if (familyDoctorModel) {
        self.titleLable.text = @"套餐选择";
        
        if (familyDoctorModel.Data.FamilyDoctorCost.count >= 4) {
            DDLogInfo(@"%@===%@",familyDoctorModel.Data.FamilyDoctorCost[0].TKey,familyDoctorModel.Data.FamilyDoctorCost[0].TValue);
            DDLogInfo(@"%@===%@",familyDoctorModel.Data.FamilyDoctorCost[1].TKey,familyDoctorModel.Data.FamilyDoctorCost[1].TValue);
            DDLogInfo(@"%@===%@",familyDoctorModel.Data.FamilyDoctorCost[2].TKey,familyDoctorModel.Data.FamilyDoctorCost[2].TValue);
            DDLogInfo(@"%@===%@",familyDoctorModel.Data.FamilyDoctorCost[3].TKey,familyDoctorModel.Data.FamilyDoctorCost[3].TValue);
            
            
            NSMutableAttributedString *oneAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[0].TKey,familyDoctorModel.Data.FamilyDoctorCost[0].TValue]];
            [oneAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                     value:UIColorFromHEX(0x333333, 1)
             
                                     range:NSMakeRange(0, 3)];
            [self.oneMothButton setAttributedTitle:oneAttributedStr forState:UIControlStateNormal];
            [self.oneMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[0].TKey,familyDoctorModel.Data.FamilyDoctorCost[0].TValue]] forState:UIControlStateNormal];
            
            
            NSMutableAttributedString *threeAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[1].TKey,familyDoctorModel.Data.FamilyDoctorCost[1].TValue]];
            
            [threeAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                       value:UIColorFromHEX(0x333333, 1)
             
                                       range:NSMakeRange(0, 3)];
            
            [self.threeMothButton setAttributedTitle:threeAttributedStr forState:UIControlStateNormal];
            [self.threeMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[1].TKey,familyDoctorModel.Data.FamilyDoctorCost[1].TValue]] forState:UIControlStateNormal];
            
            
            NSMutableAttributedString *sixAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[2].TKey,familyDoctorModel.Data.FamilyDoctorCost[2].TValue]];
            
            [sixAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                     value:UIColorFromHEX(0x333333, 1)
             
                                     range:NSMakeRange(0, 3)];
            
            [self.sixMothButton setAttributedTitle:sixAttributedStr forState:UIControlStateNormal];
            [self.sixMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[2].TKey,familyDoctorModel.Data.FamilyDoctorCost[2].TValue]] forState:UIControlStateNormal];
            
            
            NSMutableAttributedString *twAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[3].TKey,familyDoctorModel.Data.FamilyDoctorCost[3].TValue]];
            
            [twAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                    value:UIColorFromHEX(0x333333, 1)
             
                                    range:NSMakeRange(0, 4)];
            
            [self.twelveMothButton setAttributedTitle:twAttributedStr forState:UIControlStateNormal];
            [self.twelveMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@个月(%@元)",familyDoctorModel.Data.FamilyDoctorCost[3].TKey,familyDoctorModel.Data.FamilyDoctorCost[3].TValue]] forState:UIControlStateNormal];
        }
        
    }

}


#pragma mark - 改变按钮对应的到期时间
//获取当地时间
- (NSString *)getCurrentTime {
    
    //优先采用服务器时间
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentServiceTime"] == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        return dateTime;

    }else{
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date =[dateFormat dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentServiceTime"]];
        
        DDLogInfo(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentServiceTime"]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTime = [formatter stringFromDate:date];
        return dateTime;
    }
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)GetTomorrowDay:(NSDate *)aDate withDay:(NSInteger)day{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+day)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

- (void)changeTimeWithDate:(NSInteger )tag{

    switch (tag) {
        case 2001:
        {
            DDLogInfo(@"===%@===",[self getCurrentTime]);
            DDLogInfo(@"===%@===",[self dateFromString:[self getCurrentTime]]);
            DDLogInfo(@"===%@===",[self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:31]);
            _timeLabel.text = [self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:31];
        }
            break;
        case 2003:
        {
            _timeLabel.text = [self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:93];
        }
            break;
        case 2006:
        {
            _timeLabel.text = [self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:186];
        }
            break;
        case 2012:
        {
            _timeLabel.text = [self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:365];
        }
            break;
        default:
            break;
    }
    
}


- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [self.titleLable sizeToFit];
    }
    
    return _titleLable;
}



- (UIButton *)oneMothButton {
    if (!_oneMothButton) {
        _oneMothButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"1个月(269元)" titleColor:UIColorFromHEX(0xff8c28, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        _oneMothButton.tag = 2001;
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"1个月(0元)"];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:UIColorFromHEX(0x333333, 1)
         
                              range:NSMakeRange(0, 3)];
        
        [_oneMothButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        
        _oneMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        _oneMothButton.layer.borderWidth = 1.0f;
        _oneMothButton.layer.cornerRadius = 5;
        [_oneMothButton bk_whenTapped:^{
            [self changeOtherButtonStation:2001];
            if (self.oneMothSeviceBlock) {
                self.oneMothSeviceBlock();
            }
            
        }];
    }
    return _oneMothButton;
}


- (BATGraditorButton *)oneMButton{
    if (!_oneMButton) {
        _oneMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_oneMButton setTitle:@"1个月(0元)" forState:UIControlStateNormal] ;
        [_oneMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _oneMButton.userInteractionEnabled = NO;
        _oneMButton.clipsToBounds = YES;
        _oneMButton.layer.cornerRadius = 5;
        _oneMButton.hidden = YES;
        _oneMButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    
    return _oneMButton;
}


- (UIButton *)threeMothButton {
    if (!_threeMothButton) {
        _threeMothButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"3个月(700元)" titleColor:UIColorFromHEX(0xff8c28, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        _threeMothButton.tag = 2003;
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"3个月(0元)"];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:UIColorFromHEX(0x333333, 1)
         
                              range:NSMakeRange(0, 3)];
        
        [_threeMothButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        _threeMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        _threeMothButton.layer.borderWidth = 1.0f;
        _threeMothButton.clipsToBounds = YES;
        _threeMothButton.layer.cornerRadius = 5;
        [_threeMothButton bk_whenTapped:^{
            [self changeOtherButtonStation:2003];
            if (self.threeMothSeviceBlock) {
                self.threeMothSeviceBlock();
            }
        }];
    }
    return _threeMothButton;
}


- (BATGraditorButton *)threeMButton{
    if (!_threeMButton) {
        _threeMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_threeMButton setTitle:@"3个月(0元)" forState:UIControlStateNormal] ;
        [_threeMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _threeMButton.userInteractionEnabled = NO;
        _threeMButton.clipsToBounds = YES;
        _threeMButton.layer.cornerRadius = 5;
        _threeMButton.hidden = YES;
        _threeMButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _threeMButton;
}

- (UIButton *)sixMothButton {
    if (!_sixMothButton) {
        _sixMothButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"6个月(1150元)" titleColor:UIColorFromHEX(0xff8c28, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        _sixMothButton.tag = 2006;
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"6个月(0元)"];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:UIColorFromHEX(0x333333, 1)
         
                              range:NSMakeRange(0, 3)];
        
        [_sixMothButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        _sixMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        _sixMothButton.layer.borderWidth = 1.0f;
        _sixMothButton.clipsToBounds = YES;
        _sixMothButton.layer.cornerRadius = 5;
        [_sixMothButton bk_whenTapped:^{
            [self changeOtherButtonStation:2006];
            if (self.sixMothSeviceBlock) {
                self.sixMothSeviceBlock();
            }
        }];
    }
    return _sixMothButton;
}

- (BATGraditorButton *)sixMButton{
    if (!_sixMButton) {
        _sixMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_sixMButton setTitle:@"6个月(0元)" forState:UIControlStateNormal] ;
        [_sixMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _sixMButton.userInteractionEnabled = NO;
        _sixMButton.clipsToBounds = YES;
        _sixMButton.layer.cornerRadius = 5;
        _sixMButton.hidden = YES;
        _sixMButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _sixMButton;
}

- (UIButton *)twelveMothButton {
    if (!_twelveMothButton) {
        _twelveMothButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"12个月(2000元)" titleColor:UIColorFromHEX(0xff8c28, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        _twelveMothButton.tag = 2012;
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"12个月(0元)"];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:UIColorFromHEX(0x333333, 1)
         
                              range:NSMakeRange(0, 4)];
        
        [_twelveMothButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        _twelveMothButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        _twelveMothButton.layer.borderWidth = 1.0f;
        _twelveMothButton.clipsToBounds = YES;
        _twelveMothButton.layer.cornerRadius = 5;
        [_twelveMothButton bk_whenTapped:^{
            [self changeOtherButtonStation:2012];
            if (self.twelveMothSeviceBlock) {
                self.twelveMothSeviceBlock();
            }
        }];
    }
    return _twelveMothButton;
}


- (BATGraditorButton *)twelveMButton{
    if (!_twelveMButton) {
        _twelveMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_twelveMButton setTitle:@"12个月(0元)" forState:UIControlStateNormal] ;
        [_twelveMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _twelveMButton.userInteractionEnabled = NO;
        _twelveMButton.clipsToBounds = YES;
        _twelveMButton.layer.cornerRadius = 5;
        _twelveMButton.hidden = YES;
        _twelveMButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _twelveMButton;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
        _timeLabel.hidden = YES;
    }
    
    return _timeLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _dateLabel.text = @"服务到期时间";
    }
    
    return _dateLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectZero];
        _topLine.backgroundColor = BASE_LINECOLOR;
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor whiteColor];
    }
    return _bottomLine;
}

- (UIView *)bottoBGmView{
    if (!_bottoBGmView) {
        _bottoBGmView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottoBGmView.backgroundColor = BASE_LINECOLOR;
    }
    return _bottoBGmView;
}

- (UIView *)dateBGmView{
    if (!_dateBGmView) {
        _dateBGmView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _dateBGmView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
