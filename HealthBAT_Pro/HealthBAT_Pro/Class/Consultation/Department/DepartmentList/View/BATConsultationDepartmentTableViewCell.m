//
//  BATConsultationDepartmentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentTableViewCell.h"

@implementation BATConsultationDepartmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setBottomBorderWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] width:SCREEN_WIDTH height:0.5];

        [self.contentView addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@-5);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _departmentLabel.numberOfLines = 0;
        _departmentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _departmentLabel;
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
