//
//  BATFamilyDoctorPackageCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorPackageCell.h"

@implementation BATFamilyDoctorPackageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        CGFloat widthType = (SCREEN_WIDTH - 50)/4;
        WEAK_SELF(self);
        [self.contentView addSubview:self.topBGView];
        [self.topBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(45);
        }];
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.topBGView.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
        }];
        
        [self.contentView addSubview:self.topLine];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.topBGView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self.contentView addSubview:self.oneMothBGView];
        [self.oneMothBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.topBGView.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.mas_equalTo(widthType);
            make.height.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.threeMothBGView];
        [self.threeMothBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.topBGView.mas_bottom).offset(10);
            make.left.equalTo(self.oneMothBGView.mas_right).offset(10);
            make.width.mas_equalTo(widthType);
            make.height.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.sixMothBGView];
        [self.sixMothBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.topBGView.mas_bottom).offset(10);
            make.left.equalTo(self.threeMothBGView.mas_right).offset(10);
            make.width.mas_equalTo(widthType);
            make.height.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.twelveMothBGView];
        [self.twelveMothBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.topBGView.mas_bottom).offset(10);
            make.left.equalTo(self.sixMothBGView.mas_right).offset(10);
            make.width.mas_equalTo(widthType);
            make.height.mas_equalTo(80);
        }];
        
        
        [self.contentView addSubview:self.oneMothIcon];
        [self.oneMothIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.oneMothBGView.mas_top).offset(15);
            make.centerX.equalTo(self.oneMothBGView.mas_centerX);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.threeMothIcon];
        [self.threeMothIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.threeMothBGView.mas_top).offset(15);
            make.centerX.equalTo(self.threeMothBGView.mas_centerX);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.sixMothIcon];
        [self.sixMothIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.sixMothBGView.mas_top).offset(15);
            make.centerX.equalTo(self.sixMothBGView.mas_centerX);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.twelveMothIcon];
        [self.twelveMothIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.twelveMothBGView.mas_top).offset(15);
            make.centerX.equalTo(self.twelveMothBGView.mas_centerX);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.contentView addSubview:self.oneMButton];
        [self.oneMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.oneMothIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.oneMothBGView.mas_centerX);
            make.width.mas_equalTo(widthType);
        }];
        
        [self.contentView addSubview:self.threeMButton];
        [self.threeMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.threeMothIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.threeMothBGView.mas_centerX);
            make.width.mas_equalTo(widthType);
        }];
        
        [self.contentView addSubview:self.sixMButton];
        [self.sixMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.sixMothIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.sixMothBGView.mas_centerX);
            make.width.mas_equalTo(widthType);
        }];
        
        [self.contentView addSubview:self.twelveMButton];
        [self.twelveMButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.twelveMothIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.twelveMothBGView.mas_centerX);
            make.width.mas_equalTo(widthType);
        }];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.oneMothBGView.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.bottomBGView];
        [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.oneMothBGView.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(45);
            make.bottom.mas_equalTo(@0);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bottomBGView.mas_centerY);
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
        
        [self.contentView addSubview:self.oneMothClickBGView];
        [self.oneMothClickBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.oneMothBGView);
        }];
        
        [self.contentView addSubview:self.threeMothClickBGView];
        [self.threeMothClickBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.threeMothBGView);
        }];
        
        [self.contentView addSubview:self.sixMothClickBGView];
        [self.sixMothClickBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.sixMothBGView);
        }];
        
        [self.contentView addSubview:self.twelveMothClickBGView];
        [self.twelveMothClickBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.twelveMothBGView);
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
            
            self.oneMothBGView.hidden = NO;
            self.sixMothBGView.hidden = YES;
            self.threeMothBGView.hidden = YES;
            self.twelveMothBGView.hidden = YES;
            
        }
            break;
        case 2003:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMothBGView.hidden = YES;
            self.sixMothBGView.hidden = YES;
            self.threeMothBGView.hidden = NO;
            self.twelveMothBGView.hidden = YES;
            
        }
            break;
        case 2006:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMothBGView.hidden = YES;
            self.sixMothBGView.hidden = NO;
            self.threeMothBGView.hidden = YES;
            self.twelveMothBGView.hidden = YES;
      
        }
            break;
        case 2012:
        {
            _timeLabel.hidden = NO;
            [self changeTimeWithDate:tag];
            
            self.oneMothBGView.hidden = YES;
            self.sixMothBGView.hidden = YES;
            self.threeMothBGView.hidden = YES;
            self.twelveMothBGView.hidden = NO;
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
            

            [self.oneMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@元",familyDoctorModel.Data.FamilyDoctorCost[0].TValue]] forState:UIControlStateNormal];
            
            [self.threeMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@元",familyDoctorModel.Data.FamilyDoctorCost[1].TValue]] forState:UIControlStateNormal];
            
           
            [self.sixMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@元",familyDoctorModel.Data.FamilyDoctorCost[2].TValue]] forState:UIControlStateNormal];
            
          
            [self.twelveMButton setTitle:[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@元",familyDoctorModel.Data.FamilyDoctorCost[3].TValue]] forState:UIControlStateNormal];
            
            _timeLabel.hidden = NO;
            _timeLabel.text = [self GetTomorrowDay:[self dateFromString:[self getCurrentTime]] withDay:31];
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




- (UIView *)topBGView{
    if (!_topBGView) {
        _topBGView = [[UIView alloc]initWithFrame:CGRectZero];
        _topBGView.backgroundColor = [UIColor whiteColor];
    }
    return _topBGView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [self.titleLable sizeToFit];
    }
    
    return _titleLable;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectZero];
        _topLine.backgroundColor = BASE_LINECOLOR;
    }
    return _topLine;
}

- (UIImageView *)oneMothBGView{
    if (!_oneMothBGView) {
        _oneMothBGView = [[UIImageView alloc] init];
        _oneMothBGView.image = [UIImage imageNamed:@"bg-dj"];
        _oneMothBGView.hidden = NO;
        
    }
    return _oneMothBGView;
}

- (UIImageView *)threeMothBGView{
    if (!_threeMothBGView) {
        _threeMothBGView = [[UIImageView alloc] init];
        _threeMothBGView.image = [UIImage imageNamed:@"bg-dj"];
        _threeMothBGView.hidden = YES;
        
    }
    return _threeMothBGView;
}

- (UIImageView *)sixMothBGView{
    if (!_sixMothBGView) {
        _sixMothBGView = [[UIImageView alloc] init];
        _sixMothBGView.image = [UIImage imageNamed:@"bg-dj"];
        _sixMothBGView.hidden = YES;
        
    }
    return _sixMothBGView;
}

- (UIImageView *)twelveMothBGView{
    if (!_twelveMothBGView) {
        _twelveMothBGView = [[UIImageView alloc] init];
        _twelveMothBGView.image = [UIImage imageNamed:@"bg-dj"];
        _twelveMothBGView.hidden = YES;
    }
    return _twelveMothBGView;
}

- (UIImageView *)oneMothClickBGView{
    if (!_oneMothClickBGView) {
        _oneMothClickBGView = [[UIImageView alloc] init];
        _oneMothClickBGView.backgroundColor = [UIColor clearColor];
        _oneMothClickBGView.userInteractionEnabled = YES;
        _oneMothClickBGView.tag = 2001;
        [_oneMothClickBGView bk_whenTapped:^{
            [self changeOtherButtonStation:2001];
            if (self.oneMothSeviceBlock) {
                self.oneMothSeviceBlock();
            }
            
        }];
    }
    return _oneMothClickBGView;
}

- (UIImageView *)threeMothClickBGView{
    if (!_threeMothClickBGView) {
        _threeMothClickBGView = [[UIImageView alloc] init];
        _threeMothClickBGView.backgroundColor = [UIColor clearColor];
        _threeMothClickBGView.userInteractionEnabled = YES;
        _threeMothClickBGView.tag = 2003;
        [_threeMothClickBGView bk_whenTapped:^{
            [self changeOtherButtonStation:2003];
            if (self.threeMothSeviceBlock) {
                self.threeMothSeviceBlock();
            }
            
        }];
    }
    return _threeMothClickBGView;
}

- (UIImageView *)sixMothClickBGView{
    if (!_sixMothClickBGView) {
        _sixMothClickBGView = [[UIImageView alloc] init];
        _sixMothClickBGView.backgroundColor = [UIColor clearColor];
        _sixMothClickBGView.userInteractionEnabled = YES;
        _sixMothClickBGView.tag = 2006;
        [_sixMothClickBGView bk_whenTapped:^{
            [self changeOtherButtonStation:2006];
            if (self.sixMothSeviceBlock) {
                self.sixMothSeviceBlock();
            }
            
        }];
    }
    return _sixMothClickBGView;
}

- (UIImageView *)twelveMothClickBGView{
    if (!_twelveMothClickBGView) {
        _twelveMothClickBGView = [[UIImageView alloc] init];
        _twelveMothClickBGView.backgroundColor = [UIColor clearColor];
        _twelveMothClickBGView.userInteractionEnabled = YES;
        _twelveMothClickBGView.tag = 2012;
        [_twelveMothClickBGView bk_whenTapped:^{
            [self changeOtherButtonStation:2012];
            if (self.twelveMothSeviceBlock) {
                self.twelveMothSeviceBlock();
            }
            
        }];
    }
    return _twelveMothClickBGView;
}

- (UIImageView *)oneMothIcon{
    if (!_oneMothIcon) {
        _oneMothIcon = [[UIImageView alloc] init];
        _oneMothIcon.image = [UIImage imageNamed:@"ic-FD-1"];
    }
    return _oneMothIcon;
}

- (UIImageView *)threeMothIcon{
    if (!_threeMothIcon) {
        _threeMothIcon = [[UIImageView alloc] init];
        _threeMothIcon.image = [UIImage imageNamed:@"ic-FD-3"];
    }
    return _threeMothIcon;
}

- (UIImageView *)sixMothIcon{
    if (!_sixMothIcon) {
        _sixMothIcon = [[UIImageView alloc] init];
        _sixMothIcon.image = [UIImage imageNamed:@"ic-FD-6"];
    }
    return _sixMothIcon;
}

- (UIImageView *)twelveMothIcon{
    if (!_twelveMothIcon) {
        _twelveMothIcon = [[UIImageView alloc] init];
        _twelveMothIcon.image = [UIImage imageNamed:@"ic-FD-12"];
    }
    return _twelveMothIcon;
}

- (BATGraditorButton *)oneMButton{
    if (!_oneMButton) {
        _oneMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_oneMButton setTitle:@"0元" forState:UIControlStateNormal] ;
        [_oneMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _oneMButton.enbleGraditor = YES;
        _oneMButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _oneMButton;
}
- (BATGraditorButton *)threeMButton{
    if (!_threeMButton) {
        _threeMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_threeMButton setTitle:@"0元" forState:UIControlStateNormal] ;
        [_threeMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _threeMButton.enbleGraditor = YES;
        _threeMButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _threeMButton;
}
- (BATGraditorButton *)sixMButton{
    if (!_sixMButton) {
        _sixMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_sixMButton setTitle:@"0元" forState:UIControlStateNormal] ;
        [_sixMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _sixMButton.enbleGraditor = YES;
        _sixMButton.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    
    return _sixMButton;
}
- (BATGraditorButton *)twelveMButton{
    if (!_twelveMButton) {
        _twelveMButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_twelveMButton setTitle:@"0元" forState:UIControlStateNormal] ;
        [_twelveMButton setGradientColors:@[START_COLOR,END_COLOR]];
        _twelveMButton.enbleGraditor = YES;
        _twelveMButton.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    
    return _twelveMButton;
}

- (UIView *)bottomBGView{
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _bottomBGView;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = BASE_LINECOLOR;
    }
    return _bottomLine;
}


- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _dateLabel.text = @"服务到期时间";
    }
    
    return _dateLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
        _timeLabel.hidden = YES;
    }
    
    return _timeLabel;
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
