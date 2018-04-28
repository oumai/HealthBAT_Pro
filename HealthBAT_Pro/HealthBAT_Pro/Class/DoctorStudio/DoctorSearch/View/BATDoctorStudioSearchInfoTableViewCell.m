//
//  BATDoctorStudioSearchInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioSearchInfoTableViewCell.h"

@implementation BATDoctorStudioSearchInfoTableViewCell

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
    [self.contentView addSubview:self.descLabel];
    
    WEAK_SELF(self);
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(4);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.departmentAndGoodAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.hospitalLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
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
        [_doctorNameLabel sizeToFit];
    }
    return _doctorNameLabel;
}

- (UILabel *)hospitalLabel
{
    if (_hospitalLabel == nil) {
        _hospitalLabel = [[UILabel alloc] init];
        _hospitalLabel.font = [UIFont systemFontOfSize:12];
        _hospitalLabel.textColor = UIColorFromHEX(0x666666, 1);
        [_hospitalLabel sizeToFit];
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

@end
