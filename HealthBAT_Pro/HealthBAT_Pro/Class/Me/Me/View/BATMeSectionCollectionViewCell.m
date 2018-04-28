//
//  BATMeSectionCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMeSectionCollectionViewCell.h"
@interface BATMeSectionCollectionViewCell()


@end
@implementation BATMeSectionCollectionViewCell



- (instancetype) initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.iconImage = [UIImageView new];
        self.iconImage.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:_iconImage];
        
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];

        
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [self.contentView addSubview:_titleLabel];
        
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(@14);
        }];
        
        
    }
    return self;
}

@end
