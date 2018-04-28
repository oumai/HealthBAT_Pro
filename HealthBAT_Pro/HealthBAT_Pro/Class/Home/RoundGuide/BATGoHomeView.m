//
//  BATGoHomeView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/8/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATGoHomeView.h"

@interface BATGoHomeView ()

@end

@implementation BATGoHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

//        [self addSubview:self.titleLabel];
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(@0);
//            make.centerY.equalTo(@0);
//        }];
        
        [self addSubview:self.arrowImageView];
        WEAK_SELF(self);
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            STRONG_SELF(self);
            if (self.tapped) {
                self.tapped();
            }
        }];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.lee_theme.LeeConfigImage(RoundGuide_icon_jrsy);
        [_arrowImageView sizeToFit];
    }
    return _arrowImageView;
}

//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.font = [UIFont systemFontOfSize:13];
//        _titleLabel.textColor = [UIColor whiteColor];
//        [_titleLabel sizeToFit];
//        _titleLabel.text = @"进入首页";
//    }
//    return _titleLabel;
//}

@end
