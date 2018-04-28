//
//  BATConsultationDepartmentCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentCollectionViewCell.h"

@implementation BATConsultationDepartmentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        [self.contentView addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _departmentLabel.hidden = NO;
    }
    return _departmentLabel;
}

- (BATGraditorButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[BATGraditorButton alloc]init];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal] ;
        _moreBtn.enbleGraditor = YES;
        [_moreBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _moreBtn.hidden = YES;
        _moreBtn.userInteractionEnabled = NO;
    }
    return _moreBtn;
}

@end
