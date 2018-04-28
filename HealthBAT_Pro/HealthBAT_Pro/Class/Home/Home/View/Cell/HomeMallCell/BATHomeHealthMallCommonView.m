//
//  BATHomeHealthMallCommonView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthMallCommonView.h"

@implementation BATHomeHealthMallCommonView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
        }];
        
        [self addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(@10);
        }];
        
        [self addSubview:self.bottomImageView];
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-10);
            make.centerX.equalTo(@0);
        }];
        
        [self bringSubviewToFront:self.desLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _desLabel;
}

- (UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        
        _bottomImageView = [[UIImageView alloc] init];
        [_bottomImageView sizeToFit];
    }
    return _bottomImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
