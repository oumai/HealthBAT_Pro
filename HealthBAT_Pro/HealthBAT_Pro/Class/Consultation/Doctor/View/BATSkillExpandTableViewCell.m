//
//  BATSkillExpandTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/122016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSkillExpandTableViewCell.h"

@implementation BATSkillExpandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.expandButton];
        [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (UIButton *)expandButton {

    if (!_expandButton) {
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"查看详情" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        [_expandButton setImage:[UIImage imageNamed:@"iconfont-arrow-down"] forState:UIControlStateNormal];
        [_expandButton setImage:[UIImage imageNamed:@"iconfont-arrow-up"] forState:UIControlStateSelected];
        _expandButton.userInteractionEnabled = NO;
    }
    return _expandButton;
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
