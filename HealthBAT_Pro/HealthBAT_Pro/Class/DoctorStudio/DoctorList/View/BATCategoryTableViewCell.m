//
//  BATCategoryTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCategoryTableViewCell.h"

@implementation BATCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        self.selectedBackgroundView = self.selectBgView;
        
        [self pageLayout];
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
//        self.titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        [self.titleLabel setGradientColors:@[UIColorFromHEX(0x666666, 1)]];
    }
    

    // Configure the view for the selected state
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    
    [self.selectBgView addSubview:self.blueLine];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView);
    }];
    
    [self.blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.selectBgView.mas_left);
        make.top.equalTo(self.selectBgView.mas_top).offset(10);
        make.bottom.equalTo(self.selectBgView.mas_bottom).offset(-10);
        make.width.mas_offset(4);
    }];
    
    
}

#pragma mark - get & set
- (BATGraditorButton *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[BATGraditorButton alloc] init];
        _titleLabel.titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.enbleGraditor = YES;
        [_titleLabel setGradientColors:@[START_COLOR,END_COLOR]];
        _titleLabel.userInteractionEnabled = NO;
//        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
    }
    return _titleLabel;
}


- (UIView *)selectBgView
{
    if (_selectBgView == nil) {
        _selectBgView = [[UIView alloc] init];
        _selectBgView.backgroundColor = [UIColor whiteColor];
    }
    return _selectBgView;
}

- (BATGraditorButton *)blueLine
{
    if (_blueLine == nil) {
        _blueLine = [[BATGraditorButton alloc] init];
//        _blueLine.backgroundColor = UIColorFromHEX(0x0182eb, 1);
        _blueLine.enablehollowOut = YES;
        [_blueLine setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _blueLine;
}

@end
