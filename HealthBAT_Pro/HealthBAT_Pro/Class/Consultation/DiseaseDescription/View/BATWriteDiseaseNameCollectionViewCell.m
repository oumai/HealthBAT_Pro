//
//  BATWriteDiseaseNameCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWriteDiseaseNameCollectionViewCell.h"

@implementation BATWriteDiseaseNameCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 12.5f;
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.diseaseNameLabel];
        [self.diseaseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (UILabel *)diseaseNameLabel{

    if (!_diseaseNameLabel) {
        _diseaseNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _diseaseNameLabel.textAlignment = NSTextAlignmentCenter;
        _diseaseNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _diseaseNameLabel;
}

@end
