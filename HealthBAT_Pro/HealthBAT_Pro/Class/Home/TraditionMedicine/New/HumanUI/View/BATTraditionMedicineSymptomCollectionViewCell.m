//
//  BATTraditionMedicineSymptomCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionMedicineSymptomCollectionViewCell.h"

@implementation BATTraditionMedicineSymptomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {


        [self.contentView addSubview:self.symptomLabel];
        [self.symptomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.center.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.symptomBtn];
        [self.symptomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.center.equalTo(@0);
        }];

    }
    return self;
}

- (UILabel *)symptomLabel {
    if (!_symptomLabel) {
        _symptomLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _symptomLabel.backgroundColor = [UIColor whiteColor];
        _symptomLabel.layer.cornerRadius = 30;
        _symptomLabel.clipsToBounds = YES;
    }
    return _symptomLabel;
}

- (BATGraditorButton *)symptomBtn{
    
    if (!_symptomBtn) {
        _symptomBtn = [[BATGraditorButton alloc] init];
        _symptomBtn.enablehollowOut = YES;
        _symptomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _symptomBtn.titleColor = UIColorFromHEX(0x333333, 1);
        _symptomBtn.clipsToBounds= YES;
        _symptomBtn.layer.cornerRadius = 30;
        _symptomBtn.titleColor = [UIColor whiteColor];
        _symptomBtn.hidden = YES;
        [_symptomBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _symptomBtn.userInteractionEnabled = NO;
    }
    return _symptomBtn;
}


- (void)selectCellWithYesAndNo:(BOOL)state{
    
    if(state == YES){
        self.symptomBtn.hidden = NO;
    }else{
        self.symptomBtn.hidden = YES;
    }
}

@end
