//
//  BATDrugOrderLogisticsInfoTableViewCell.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderLogisticsInfoTableViewCell.h"

@implementation BATDrugOrderLogisticsInfoTableViewCell

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
        
        [self.contentView addSubview:self.queryBtn];
        [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@7.5);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(30);
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

- (BATGraditorButton *)queryBtn {
    
    if (!_queryBtn) {
        
        _queryBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        
        [_queryBtn setTitle:@"查看物流详情" forState:UIControlStateNormal];
        _queryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _queryBtn.layer.cornerRadius = 5.0f;
        _queryBtn.layer.masksToBounds = YES;
        
        [_queryBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _queryBtn.enablehollowOut = NO;
        
        [_queryBtn bk_whenTapped:^{
            
            if (self.queryBlock) {
                self.queryBlock();
            }
        }];
    }
    return _queryBtn;
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
