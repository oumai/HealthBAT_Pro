//
//  AreaTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAreaTableViewCell.h"
#import "UIView+Border.h"

@implementation BATAreaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:0 height:0];
        
        [self.contentView addSubview:self.areaNameLabel];
        [self.areaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@-5);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

- (UILabel *)areaNameLabel {
    if (!_areaNameLabel) {
        _areaNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _areaNameLabel.numberOfLines = 0;
        _areaNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _areaNameLabel;
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
