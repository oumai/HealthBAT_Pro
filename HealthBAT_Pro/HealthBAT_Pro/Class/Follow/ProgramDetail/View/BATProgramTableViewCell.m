//
//  BATProgramTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramTableViewCell.h"

@implementation BATProgramTableViewCell

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

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    
    WEAK_SELF(self);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_left).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(7, 11));
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (BATGraditorButton *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[BATGraditorButton alloc] init];
        _timeLabel.titleLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.titleLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.enbleGraditor = YES;
    }
    return _timeLabel;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-jt"]];
    }
    return _arrowImageView;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
