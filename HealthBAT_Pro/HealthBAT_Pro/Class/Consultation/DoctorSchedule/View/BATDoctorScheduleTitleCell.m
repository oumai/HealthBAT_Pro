//
//  BATDoctorScheduleTitleCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleTitleCell.h"

@implementation BATDoctorScheduleTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:12];
//        _titleLabel.layer.borderColor = UIColorFromHEX(0xf6f6f6, 1).CGColor;
//        _titleLabel.layer.borderWidth = 0.5f;
        [self.contentView addSubview:_titleLabel];
        
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
