//
//  BATRoundHeaderView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/8/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRoundHeaderView.h"

@implementation BATRoundHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 30 / 2;
        
        [self addSubview:self.headerView];
        WEAK_SELF(self);
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
//        [self addSubview:self.nameLabel];
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.headerView.mas_right).offset(10);
//            make.centerY.equalTo(@0);
//        }];
    }
    return self;
}

- (UIImageView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerView.layer.cornerRadius = 28.0f / 2;
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor whiteColor];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
