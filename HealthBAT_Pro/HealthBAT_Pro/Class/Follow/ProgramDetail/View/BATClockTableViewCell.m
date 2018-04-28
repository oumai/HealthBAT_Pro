//
//  BATClockTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATClockTableViewCell.h"

@implementation BATClockTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
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

- (void)switchOnAction:(UITapGestureRecognizer *)switchOn
{
    if (self.switchAction) {
        self.switchAction();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.clockImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.switchImageView];
    
    WEAK_SELF(self);
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.clockImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.switchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 31));
    }];
}

#pragma mark - get & set
- (UIImageView *)clockImageView
{
    if (_clockImageView == nil) {
        _clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-lz"]];
    }
    return _clockImageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.text = @"闹钟";
    }
    return _titleLabel;
}

- (UISwitch *)switchOn
{
    if (_switchOn == nil) {
        _switchOn = [[UISwitch alloc] init];
        _switchOn.onTintColor = UIColorFromHEX(0xff8c28, 1);
        [_switchOn addTarget:self action:@selector(switchOnAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchOn;
}

- (UIImageView *)switchImageView {

    if (!_switchImageView) {
        _switchImageView = [[UIImageView alloc]init];
        
        _switchImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchOnAction:)];
        [_switchImageView addGestureRecognizer:tap];
        
    }
    return _switchImageView;
}

@end
