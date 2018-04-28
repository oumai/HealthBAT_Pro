//
//  BATFamilyDoctorOrderInfoMidCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderInfoMidCell.h"

@implementation BATFamilyDoctorOrderInfoMidCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self pageLayouts];
    }
    
    return self;
}

- (void)pageLayouts{
    
    [self.contentView addSubview:self.serverTypeLabel];
    [self.serverTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@90);
    }];
    
    [self.contentView addSubview:self.serverTypeDescLabel];
    [self.serverTypeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serverTypeLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.serverTypeLabel.mas_top);
    }];
    
    [self.contentView addSubview:self.serverDoctorNameLabel];
    [self.serverDoctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverTypeDescLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@90);
    }];
    
    [self.contentView addSubview:self.serverDoctorNameDescLabel];
    [self.serverDoctorNameDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverDoctorNameLabel.mas_top);
        make.left.equalTo(self.serverDoctorNameLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.contentView addSubview:self.consultServerLabel];
    [self.consultServerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverDoctorNameDescLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@90);
    }];
    
    [self.contentView addSubview:self.consultServerDescLabel];
    [self.consultServerDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consultServerLabel.mas_top);
        make.left.equalTo(self.consultServerLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.contentView addSubview:self.serverTimeLabel];
    [self.serverTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consultServerDescLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@90);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-28.5);
    }];
    
    [self.contentView addSubview:self.serverTimeDescLabel];
    [self.serverTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverTimeLabel.mas_top);
        make.left.equalTo(self.serverTimeLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UILabel *)serverTypeLabel{
    if (!_serverTypeLabel) {
        _serverTypeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _serverTypeLabel.text = @"服务类型：";
    }
    
    return _serverTypeLabel;
}

- (UILabel *)serverTypeDescLabel{
    if (!_serverTypeDescLabel) {
        _serverTypeDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _serverTypeDescLabel.numberOfLines = 0;
        
    }
    
    return _serverTypeDescLabel;
}

- (UILabel *)serverDoctorNameLabel{
    if (!_serverDoctorNameLabel) {
        _serverDoctorNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _serverDoctorNameLabel.text = @"服务医生：";
    }
    
    return _serverDoctorNameLabel;
}

- (UILabel *)serverDoctorNameDescLabel{
    if (!_serverDoctorNameDescLabel) {
        _serverDoctorNameDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _serverDoctorNameDescLabel.numberOfLines = 0;
    }
    
    return _serverDoctorNameDescLabel;
}



- (UILabel *)consultServerLabel{
    if (!_consultServerLabel) {
        _consultServerLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _consultServerLabel.text = @"咨询套餐：";
    }
    
    return _consultServerLabel;
}

- (UILabel *)consultServerDescLabel{
    if (!_consultServerDescLabel) {
        _consultServerDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _consultServerDescLabel.numberOfLines = 0;
    }
    
    return _consultServerDescLabel;
}



- (UILabel *)serverTimeLabel{
    if (!_serverTimeLabel) {
        _serverTimeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _serverTimeLabel.text = @"服务时间：";
    }
    
    return _serverTimeLabel;
}

- (UILabel *)serverTimeDescLabel{
    if (!_serverTimeDescLabel) {
        _serverTimeDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _serverTimeDescLabel.numberOfLines = 0;
    }
    
    return _serverTimeDescLabel;
}


@end
