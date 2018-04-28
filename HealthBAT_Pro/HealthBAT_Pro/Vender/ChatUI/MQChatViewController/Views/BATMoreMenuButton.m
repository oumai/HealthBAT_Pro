//
//  BATMoreMenuButton.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMoreMenuButton.h"

@implementation BATMoreMenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button];
        
        WEAK_SELF(self);
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.mas_top).offset(15);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(27, 24));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self);
            make.top.equalTo(_imageView.mas_bottom).offset(15);
        }];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
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

@end
