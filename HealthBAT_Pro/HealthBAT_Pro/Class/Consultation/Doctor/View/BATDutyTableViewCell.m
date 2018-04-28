//
//  DutyTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDutyTableViewCell.h"

@implementation BATDutyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAK_SELF(self);
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(120);
        }];

        [self.contentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.timeLabel.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(50);
        }];

        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.countLabel.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self.contentView addSubview:self.registerButton];
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}
#pragma mark - setter getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _countLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"" titleColor:[UIColor whiteColor] backgroundColor:[UIColor whiteColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];

        [_registerButton.layer setCornerRadius:3.0f];
        WEAK_SELF(self);
        [_registerButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.hospitalRegister) {
                self.hospitalRegister();
            }
        }];
    }
    return _registerButton;
}


#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
