//
//  BATConsultionHomeNewTopCollectionViewDeptCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeNewTopCollectionViewDeptCell.h"

@implementation BATConsultionHomeNewTopCollectionViewDeptCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat range;
        if (iPhone5) {
            range = 10;
        }else if(iPhone6){
            range = 15;
        }else{
            range = 20;
        }
        
        WEAK_SELF(self);
        [self addSubview:self.deptImageView];
        [self.deptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY).offset(-15);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.deptLable];
        [self.deptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-range);
        }];
    }
    return self;
}


- (UILabel *)deptLable{
    if (!_deptLable) {
        _deptLable = [[UILabel alloc]init];
        _deptLable.textColor = UIColorFromHEX(0x333333, 1);
        _deptLable.font = [UIFont systemFontOfSize:13];
        _deptLable.textAlignment = NSTextAlignmentCenter;
        [_deptLable sizeToFit];
    }
    return _deptLable;
}


- (UIImageView *)deptImageView{
    if (!_deptImageView) {
        _deptImageView = [[UIImageView alloc]init];
    }
    return _deptImageView;
}


@end
