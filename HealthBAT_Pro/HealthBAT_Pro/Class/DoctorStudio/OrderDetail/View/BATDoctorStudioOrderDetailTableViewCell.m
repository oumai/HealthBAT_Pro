//
//  BATDoctorStudioOrderDetailTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/6/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioOrderDetailTableViewCell.h"

@implementation BATDoctorStudioOrderDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];

    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentRight];
    }
    return _desLabel;
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
