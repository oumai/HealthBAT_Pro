//
//  BATMessageCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMessageCell.h"


@implementation BATMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.iconImageV];
        [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(14);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(48);
        }];
        
        [self.contentView addSubview:self.unreadLabel];
        [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconImageV.mas_top).offset(-3);
            make.right.equalTo(self.iconImageV.mas_right).offset(3);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconImageV.mas_top).offset(5);
            make.right.equalTo(self.mas_right).offset(-14);
            make.height.mas_equalTo(20);
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconImageV.mas_top).offset(5);
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.right.equalTo(self.timeLabel.mas_left).offset(-10);
            make.height.mas_equalTo(20);
           
        }];
        
        [self.contentView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.iconImageV.mas_right).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH - 100);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (UIImageView *)iconImageV{
    if(!_iconImageV){
        _iconImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageV.layer.cornerRadius = 24.f;
        _iconImageV.clipsToBounds = YES;
    }
    return _iconImageV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromHEX(0x666666, 1);
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = UIColorFromHEX(0x333333, 1);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.textColor = UIColorFromHEX(0x999999, 1);
        _descLabel.font = [UIFont systemFontOfSize:16];
    }
    return _descLabel;
}

- (UILabel *)unreadLabel{
    if (!_unreadLabel) {
        _unreadLabel = [[UILabel alloc]init];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.layer.cornerRadius = 10.f;
        _unreadLabel.clipsToBounds = YES;
    }
    return _unreadLabel;
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
