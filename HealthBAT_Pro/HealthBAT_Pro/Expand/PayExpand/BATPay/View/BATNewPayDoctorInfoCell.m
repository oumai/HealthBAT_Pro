//
//  BATNewPayDoctorInfoCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayDoctorInfoCell.h"

@implementation BATNewPayDoctorInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self pageLayouts];
    }
    
    return self;
}

- (void)pageLayouts{
    
    WEAK_SELF(self);
    [self.contentView addSubview:self.doctorImageView];
    [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.contentView addSubview:self.doctorName];
    [self.doctorName mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.doctorImageView);
        make.left.equalTo(self.doctorImageView.mas_right).offset(20);
    
    }];
    
    [self.contentView addSubview:self.rightIcon];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.doctorImageView);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.doctorImageView);
        make.right.equalTo(self.rightIcon.mas_left).offset(-10);
    }];
}



- (UIImageView *)doctorImageView{
    if (!_doctorImageView) {
        _doctorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        _doctorImageView.clipsToBounds = YES;
        _doctorImageView.layer.cornerRadius = 25;
        
    }
    return _doctorImageView;
}


- (UILabel *)doctorName{
    if (!_doctorName) {
        _doctorName = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _doctorName.text = @"康小美";
        [_doctorName sizeToFit];
    }
    
    return _doctorName;
}

- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _timeLable.text = @"预约时间";
        _timeLable.userInteractionEnabled = YES;
        [_timeLable sizeToFit];
        
        [_timeLable bk_whenTapped:^{
            if (self.chooseConsultingTime) {
                self.chooseConsultingTime();
            }
        }];
    }
    
    return _timeLable;
}


- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _rightIcon;
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
