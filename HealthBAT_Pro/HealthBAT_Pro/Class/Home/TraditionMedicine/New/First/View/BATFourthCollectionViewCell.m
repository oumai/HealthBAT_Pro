//
//  BATFourthCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFourthCollectionViewCell.h"

@implementation BATFourthCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {


        [self.contentView addSubview:self.answerLabel];
        [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-20)/5.0-20, (SCREEN_WIDTH-20)/5.0-20));
            make.center.equalTo(@0);
        }];
        
    }
    return self;
}

- (UILabel *)answerLabel {
    if (!_answerLabel) {
        _answerLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _answerLabel.backgroundColor = [UIColor whiteColor];
        _answerLabel.layer.cornerRadius = ((SCREEN_WIDTH-20)/5.0 - 20)/2.0;
        _answerLabel.clipsToBounds = YES;
    }
    return _answerLabel;
}

@end
