//
//  BATHomeHealthStepRightView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/102017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthStepRightView.h"

@implementation BATHomeHealthStepRightView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@15);
        }];
        
        [self addSubview:self.unitLabel];
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentLabel.mas_right).offset(2);
            make.bottom.equalTo(self.contentLabel.mas_bottom).offset(0);
        }];
        
        [self addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(@10);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(2);
        }];
        
        [self addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        [_rightImageView sizeToFit];
    }
    return _rightImageView;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:25] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
        _contentLabel.text = @"步数";
    }
    return _contentLabel;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _desLabel.text = @"步数";
    }
    return _desLabel;
}

- (UILabel *)unitLabel {
    
    if (!_unitLabel) {
        
        _unitLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:STRING_LIGHT_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _unitLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
