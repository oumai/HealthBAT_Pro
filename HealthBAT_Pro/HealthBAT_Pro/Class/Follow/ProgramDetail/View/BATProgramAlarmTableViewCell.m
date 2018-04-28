//
//  BATProgramAlarmTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/2/2.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATProgramAlarmTableViewCell.h"

@implementation BATProgramAlarmTableViewCell

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

#pragma mark - Action
- (void)alarmSwitchAction:(UISwitch *)aSwitch
{
    if (self.alarmBlock) {
        self.alarmBlock(aSwitch.on);
    }
}

#pragma makr - Layout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.alarmSwitch];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.top.equalTo(self.contentView);
        make.height.mas_offset(45);
    }];
    
    [self.alarmSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (UISwitch *)alarmSwitch
{
    if (_alarmSwitch == nil) {
        _alarmSwitch = [[UISwitch alloc] init];
        [_alarmSwitch addTarget:self action:@selector(alarmSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _alarmSwitch;
}

@end
