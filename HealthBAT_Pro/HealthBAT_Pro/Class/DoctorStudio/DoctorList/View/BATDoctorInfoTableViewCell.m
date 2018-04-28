//
//  BATDoctorInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorInfoTableViewCell.h"

@implementation BATDoctorInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self pageLayout];
        
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.doctorNameLabel];
    [self.contentView addSubview:self.hospitalLabel];
    [self.contentView addSubview:self.departmentAndGoodAtLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceCountLabel];
    
    WEAK_SELF(self);
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12.5);
    }];
    
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(12.5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.departmentAndGoodAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.hospitalLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.departmentAndGoodAtLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0 / [UIScreen mainScreen].scale);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
    }];
    
    [self.priceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.priceLabel.mas_right).offset(10);
        make.top.equalTo(self.priceLabel.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
}

#pragma mark - get & set
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 60 / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)doctorNameLabel
{
    if (_doctorNameLabel == nil) {
        _doctorNameLabel = [[UILabel alloc] init];
        _doctorNameLabel.font = [UIFont systemFontOfSize:15];
        _doctorNameLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _doctorNameLabel;
}

- (UILabel *)hospitalLabel
{
    if (_hospitalLabel == nil) {
        _hospitalLabel = [[UILabel alloc] init];
        _hospitalLabel.font = [UIFont systemFontOfSize:12];
        _hospitalLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _hospitalLabel;
}

- (UILabel *)departmentAndGoodAtLabel
{
    if (_departmentAndGoodAtLabel == nil) {
        _departmentAndGoodAtLabel = [[UILabel alloc] init];
        _departmentAndGoodAtLabel.font = [UIFont systemFontOfSize:12];
        _departmentAndGoodAtLabel.textColor = UIColorFromHEX(0x666666, 1);
        [_departmentAndGoodAtLabel sizeToFit];
    }
    return _departmentAndGoodAtLabel;
}

- (UILabel *)line
{
    if (_line == nil) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = BASE_LINECOLOR;
    }
    return _line;
}

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = UIColorFromHEX(0x666666, 1);
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

- (UILabel *)priceCountLabel
{
    if (_priceCountLabel == nil) {
        _priceCountLabel = [[UILabel alloc] init];
        _priceCountLabel.font = [UIFont systemFontOfSize:12];
        _priceCountLabel.textColor = UIColorFromHEX(0x666666, 1);
        [_priceCountLabel sizeToFit];
    }
    return _priceCountLabel;
}

@end
