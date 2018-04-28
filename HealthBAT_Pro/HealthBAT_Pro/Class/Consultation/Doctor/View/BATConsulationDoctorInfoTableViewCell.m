//
//  BATConsulationDoctorInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsulationDoctorInfoTableViewCell.h"

@implementation BATConsulationDoctorInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.skilLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_greaterThanOrEqualTo(30);
        }];
        
        [self.skilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.height.mas_greaterThanOrEqualTo(14);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)skilLabel {
    
    if (!_skilLabel) {
        _skilLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _skilLabel.font = [UIFont systemFontOfSize:14];
        _skilLabel.textAlignment = NSTextAlignmentLeft;
        _skilLabel.textColor = UIColorFromHEX(0x666666, 1);
        _skilLabel.numberOfLines = 0;
        [_skilLabel sizeToFit];
    }
    return _skilLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
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
