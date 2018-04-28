//
//  BATFindNewTitleView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindNewTitleView.h"

@implementation BATFindNewTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        
        [self pagesLayout];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Action
- (void)buttonAction:(UIButton *)button
{
    if (self.findNewTitleClick) {
        self.findNewTitleClick(self.section);
    }
}

#pragma mark - Layout
- (void)pagesLayout
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.accessoryImageView];
    [self addSubview:self.button];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.mas_top).offset(11);
//        make.bottom.equalTo(self.mas_bottom).offset(-11);
        make.centerY.equalTo(self.mas_centerY);
    }];
    

//
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(2);
        make.right.equalTo(self.mas_right).offset(-12);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.left.equalTo(self.titleLabel).offset(5);
        //        make.top.equalTo(self.mas_top).offset(11);
        //        make.bottom.equalTo(self.mas_bottom).offset(-11);
        make.width.mas_offset(42);
        make.right.equalTo(self.accessoryImageView.mas_left).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get&set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"更多";
        _detailLabel.textColor = UIColorFromHEX(0x999999, 1);
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

- (UIImageView *)accessoryImageView
{
    if (_accessoryImageView == nil) {
        _accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
    }
    return _accessoryImageView;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
