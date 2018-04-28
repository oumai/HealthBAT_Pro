//
//  BATHosptialCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHosptialCell.h"

@implementation BATHosptialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.hospitalImageView];
        [self.hospitalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(19);
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.height.mas_equalTo(66);
            make.width.mas_equalTo(77);
        }];
        
        
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.numberOfLines = 0;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(19);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.titleAddressLabel];
        [self.titleAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        //        [self.contentView addSubview:self.addressLabel];
        //        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            STRONG_SELF(self);
        //            make.left.equalTo(self.titleAddressLabel.mas_right).offset(5);
        //            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        //            make.bottom.equalTo(self.titleAddressLabel.mas_bottom);
        //        }];
        
        [self.contentView addSubview:self.titlePhoneLabel];
        [self.titlePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.equalTo(self.titleAddressLabel.mas_bottom).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        //        [self.contentView addSubview:self.phoneLabel];
        //        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            STRONG_SELF(self);
        //            make.left.equalTo(self.titlePhoneLabel.mas_right).offset(5);
        //            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        //            make.bottom.equalTo(self.titlePhoneLabel.mas_bottom);
        //        }];
        
        [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UIImageView *)hospitalImageView {
    if (!_hospitalImageView) {
        _hospitalImageView = [UIImageView new];
    }
    return _hospitalImageView;
}

- (UILabel *)propertyLabel {
    if (!_propertyLabel) {
        _propertyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _propertyLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _phoneLabel;
}

- (UILabel *)titlePropertyLabel {
    if (!_titlePropertyLabel) {
        _titlePropertyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        _titlePropertyLabel.text = @"类型：";
    }
    return _titlePropertyLabel;
}

- (UILabel *)titleAddressLabel {
    if (!_titleAddressLabel) {
        _titleAddressLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        //        _titleAddressLabel.text = @"地址：";
        
    }
    return _titleAddressLabel;
}

- (UILabel *)titlePhoneLabel {
    if (!_titlePhoneLabel) {
        _titlePhoneLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        //        _titlePhoneLabel.text = @"电话：";
        
    }
    return _titlePhoneLabel;
}

@end
