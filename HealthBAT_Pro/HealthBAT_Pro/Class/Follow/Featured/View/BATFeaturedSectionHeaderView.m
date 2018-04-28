//
//  BATAlbumCellHeadView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFeaturedSectionHeaderView.h"
#import "UIButton+TouchAreaInsets.h"

@implementation BATFeaturedSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topSeparatorView];
        [self addSubview:self.leftTitleLabel];
        [self addSubview:self.rightButton];
        [self addSubview:self.separatorView];
    }
    return self;
}

#pragma mark - Action

- (void)rightButtonClick{
    
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
    
}
#pragma mark - 布局子控件

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(10);
        
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topSeparatorView.mas_bottom);
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(self.leftTitleLabel);
        
        
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.mas_equalTo(0);
        
    }];
    
}

#pragma mark - lazy load
- (UIView *)topSeparatorView{
    if (!_topSeparatorView) {
        _topSeparatorView = [[UIView alloc]init];
        _topSeparatorView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    }
    return _topSeparatorView;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        [_rightButton setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateNormal];
         [_rightButton setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateHighlighted];
        _rightButton.touchAreaInsets = UIEdgeInsetsMake(5, 100, 5, 10);
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _rightButton;
}
- (UILabel *)leftTitleLabel{
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _leftTitleLabel.font = [UIFont systemFontOfSize:15];
        _leftTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    }
    return _leftTitleLabel;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _separatorView;
}
@end
