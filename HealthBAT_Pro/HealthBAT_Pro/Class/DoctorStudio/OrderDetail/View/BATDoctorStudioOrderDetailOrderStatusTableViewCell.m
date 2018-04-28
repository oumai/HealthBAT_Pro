//
//  BATDoctorStudioOrderDetailOrderStatusTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/6/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioOrderDetailOrderStatusTableViewCell.h"

@implementation BATDoctorStudioOrderDetailOrderStatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.desLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.right.equalTo(self.mas_centerX).offset(-10);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(self.mas_centerX);
        }];
    }
    return self;
}
#pragma mark - getter
- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
        
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
