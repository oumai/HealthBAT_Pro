//
//  BATTFamilyDoctorOrderInfoTopCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderInfoTopCell.h"

@implementation BATFamilyDoctorOrderInfoTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self pageLayouts];
    }
    
    return self;
}

- (void)pageLayouts{
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@105);
    }];
    
    [self.contentView addSubview:self.nameDescLabel];
    [self.nameDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nameLabel.mas_top);
    }];
    
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameDescLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@50);
    }];
    
    [self.contentView addSubview:self.phoneDescLabel];
    [self.phoneDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_top);
        make.left.equalTo(self.phoneLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneDescLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(@50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-28.5);
    }];
    
    [self.contentView addSubview:self.addressDescLabel];
    [self.addressDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_top);
        make.left.equalTo(self.addressLabel.mas_right).offset(0);
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

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _nameLabel.text = @"服务签约人：";
    }
    
    return _nameLabel;
}

- (UILabel *)nameDescLabel{
    if (!_nameDescLabel) {
        _nameDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _nameDescLabel.numberOfLines = 0;
        
    }
    
    return _nameDescLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _phoneLabel.text = @"电话：";
    }
    
    return _phoneLabel;
}

- (UILabel *)phoneDescLabel{
    if (!_phoneDescLabel) {
        _phoneDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _phoneDescLabel.numberOfLines = 0;
    }
    
    return _phoneDescLabel;
}



- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _addressLabel.text = @"地址：";
    }
    
    return _addressLabel;
}

- (UILabel *)addressDescLabel{
    if (!_addressDescLabel) {
        _addressDescLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0X333333, 1) textAlignment:NSTextAlignmentLeft];
        _addressDescLabel.numberOfLines = 0;
    }
    
    return _addressDescLabel;
}


@end
