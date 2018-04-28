//
//  BATDoctorSortTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorSortTableViewCell.h"

@implementation BATDoctorSortTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self pageLayout];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
//        self.titleLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        [self.titleLabel setGradientColors:@[START_COLOR,END_COLOR]];
    } else {
        [_titleLabel setGradientColors:@[UIColorFromHEX(0x666666, 1)]];
    }
    
    
    // Configure the view for the selected state
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(18, 15, 18, 15));
    }];
}

#pragma mark - get & set
- (BATGraditorButton *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[BATGraditorButton alloc] init];
        _titleLabel.titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.enbleGraditor = YES;
        [_titleLabel setGradientColors:@[UIColorFromHEX(0x666666, 1)]];
    }
    return _titleLabel;
}


@end
