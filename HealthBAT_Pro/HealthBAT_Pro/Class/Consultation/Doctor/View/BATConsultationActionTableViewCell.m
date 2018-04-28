//
//  BATConsultationActionTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/82016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationActionTableViewCell.h"

@implementation BATConsultationActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.consulteButton];
        [self.consulteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];

        [self.contentView addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(47);
            make.height.mas_equalTo(47);
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(17);
            make.top.equalTo(self).offset(22);
        }];

        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(18);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.right.lessThanOrEqualTo(self.consulteButton.mas_left).offset(-10);
        }];

        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(17);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];

        [self.contentView addSubview:self.numberTitleLabel];
        [self.numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.consulteButton.mas_left).offset(-40);
            make.top.equalTo(self.priceLabel.mas_top);
        }];

        [self.contentView addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberTitleLabel.mas_right);
            make.top.equalTo(self.numberTitleLabel.mas_top);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)leftImageView {

    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x292828, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)priceLabel {

    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0xff0000, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (UILabel *)numberTitleLabel {

    if (!_numberTitleLabel) {
        _numberTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _numberTitleLabel;
}

- (UILabel *)numberLabel {

    if (!_numberLabel) {
        _numberLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0xfc9f26, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _numberLabel;
}

- (UIButton *)consulteButton {

    if (!_consulteButton) {
        
        _consulteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consulteButton setTitle:@"立即咨询" forState:UIControlStateNormal];
        [_consulteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _consulteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_consulteButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xfc9f26, 1)] forState:UIControlStateNormal];
        [_consulteButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xcdcdcd, 1)] forState:UIControlStateDisabled];
        _consulteButton.layer.cornerRadius = 3.0f;
        _consulteButton.layer.masksToBounds = YES;
        
        [_consulteButton bk_whenTapped:^{
            if (self.consultBlock) {
                self.consultBlock();
            }
        }];
    }
    return _consulteButton;
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
