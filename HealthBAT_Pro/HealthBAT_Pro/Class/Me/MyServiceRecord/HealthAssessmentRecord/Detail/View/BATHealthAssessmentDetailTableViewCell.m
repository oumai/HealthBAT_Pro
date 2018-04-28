//
//  BATHealthAssessmentDetailTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/10/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthAssessmentDetailTableViewCell.h"

@implementation BATHealthAssessmentDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(44);
            make.leading.top.equalTo(@5);
            make.trailing.bottom.equalTo(@-5);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (UILabel *)desLabel {

    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
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
