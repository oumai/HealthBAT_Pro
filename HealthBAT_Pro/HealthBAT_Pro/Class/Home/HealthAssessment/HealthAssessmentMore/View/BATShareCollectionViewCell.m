//
//  BATShareCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATShareCollectionViewCell.h"

@implementation BATShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImageV = [[UIImageView alloc]init];
        _iconImageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImageV];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = UIColorFromRGB(102, 102, 102, 1);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView).mas_offset(5);
            make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - 20)/4.0 - 25, (SCREEN_WIDTH - 20)/4.0 - 25));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.iconImageV.mas_bottom).mas_offset(10);
            make.size.mas_offset(CGSizeMake(frame.size.width, 20));
        }];
    }
    return self;
}

@end
