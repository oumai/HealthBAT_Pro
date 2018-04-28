//
//  BATConsultationDoctorSkillTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/82016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorSkillTableViewCell.h"

@implementation BATConsultationDoctorSkillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.skilLabel];
        
        [self.skilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
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
        _skilLabel.numberOfLines = 3;
    }
    return _skilLabel;
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
