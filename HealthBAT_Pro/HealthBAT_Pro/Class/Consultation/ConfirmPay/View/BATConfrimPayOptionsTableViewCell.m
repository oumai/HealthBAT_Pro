//
//  BATConfrimPayOptionsTableViewCell.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConfrimPayOptionsTableViewCell.h"

@implementation BATConfrimPayOptionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _optionsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_optionsImageView];

        _optionsTitleLabel = [[UILabel alloc] init];
        _optionsTitleLabel.font = [UIFont systemFontOfSize:15];
        _optionsTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [self.contentView addSubview:_optionsTitleLabel];

        _selectImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectImageView];

        _line = [[UILabel alloc] init];
        _line.backgroundColor = UIColorFromRGB(226, 226, 227, 1);
        [self.contentView addSubview:_line];

        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_optionsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];

    [_optionsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(_optionsImageView.mas_right).offset(15);
        make.top.right.bottom.equalTo(self.contentView);
    }];

    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        
    }];

    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo((1.0 / [UIScreen mainScreen].scale));
    }];
}

@end
