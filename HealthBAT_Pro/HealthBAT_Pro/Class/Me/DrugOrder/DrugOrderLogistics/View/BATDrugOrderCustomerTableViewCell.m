//
//  BATDrugOrderCustomerTableViewCell.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderCustomerTableViewCell.h"

@implementation BATDrugOrderCustomerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(35);
        }];
        
        [self.contentView addSubview:self.sexLabel];
        [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(35);
        }];
        
        [self.contentView addSubview:self.birthdayLabel];
        [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.bottom.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(35);
        }];
        
        [self.contentView addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.bottom.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(35);
        }];

    }
    return self;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel sizeToFit];
        _nameLabel.font = [UIFont systemFontOfSize:15];

    }
    return _nameLabel;
}

- (UILabel *)sexLabel {
    
    if (!_sexLabel) {
        
        _sexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_sexLabel sizeToFit];
        _sexLabel.font = [UIFont systemFontOfSize:15];

    }
    return _sexLabel;
}

- (UILabel *)birthdayLabel {
    
    if (!_birthdayLabel) {
        
        _birthdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_birthdayLabel sizeToFit];
        _birthdayLabel.font = [UIFont systemFontOfSize:15];

    }
    return _birthdayLabel;
}

- (UILabel *)phoneLabel {
    
    if (!_phoneLabel) {
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_phoneLabel sizeToFit];
        _phoneLabel.font = [UIFont systemFontOfSize:15];

    }
    return _phoneLabel;
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
