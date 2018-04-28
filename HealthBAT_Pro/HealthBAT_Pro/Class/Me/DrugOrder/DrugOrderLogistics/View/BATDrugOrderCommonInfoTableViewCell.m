//
//  BATDrugOrderCommonInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderCommonInfoTableViewCell.h"

@implementation BATDrugOrderCommonInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.leftTitleLabel];
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@0);
            make.right.lessThanOrEqualTo(@0);
            make.height.mas_equalTo(45);
        }];
        
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(45);
        }];
    }
    return self;
}

- (UILabel *)leftTitleLabel {
    
    if (!_leftTitleLabel) {
        
        _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_leftTitleLabel sizeToFit];
        _leftTitleLabel.font = [UIFont systemFontOfSize:15];

    }
    return _leftTitleLabel;
}

- (UILabel *)rightLabel {
    
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:15];

        [_rightLabel sizeToFit];
    }
    return _rightLabel;
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
