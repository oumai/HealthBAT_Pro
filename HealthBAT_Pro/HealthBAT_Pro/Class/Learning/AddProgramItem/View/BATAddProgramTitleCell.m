//
//  BATAddProgramTitleCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddProgramTitleCell.h"

@implementation BATAddProgramTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.contentView addSubview:self.titleTextField];
    [self.contentView addSubview:self.arrowImageView];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
//        make.width.mas_equalTo(100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(7, 11));
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.arrowImageView.hidden = YES;
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (UITextField *)titleTextField
{
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.font = [UIFont systemFontOfSize:15];
        _titleTextField.textColor = UIColorFromHEX(0x333333, 1);
        _titleTextField.textAlignment = NSTextAlignmentRight;
    }
    return _titleTextField;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-jt"]];
    }
    return _arrowImageView;
}

@end
