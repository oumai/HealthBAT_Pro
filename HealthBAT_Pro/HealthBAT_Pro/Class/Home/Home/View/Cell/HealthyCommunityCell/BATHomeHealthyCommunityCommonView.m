//
//  BATHomeHealthyCommunityCommonView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/11/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthyCommunityCommonView.h"
@interface BATHomeHealthyCommunityCommonView ()

@end

@implementation BATHomeHealthyCommunityCommonView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightImageView];
        [self addSubview:self.descLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(self.rightImageView.mas_left).offset(-4);
        
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
//        make.width.mas_equalTo(SCREEN_WIDTH/4.0);
//        make.height.mas_equalTo(self);
        
    }];
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.layer.cornerRadius = 5.0f;
        _rightImageView.clipsToBounds = YES;
        [_rightImageView sizeToFit];
    }
    return _rightImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"这是标题";

    }
    return _titleLabel;
}
- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
        _descLabel.text= @"这是描述文字";
    }
    return _descLabel;
}
@end
