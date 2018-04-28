//
//  BATDrugOrderHeader.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderHeader.h"

@implementation BATDrugOrderHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
                
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(45);
        }];
        
        [self addSubview:self.statusLaebl];
        [self.statusLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@0);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2.0);
            make.height.mas_equalTo(45);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)statusLaebl {
    
    if (!_statusLaebl) {
        
        _statusLaebl = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLaebl.font = [UIFont systemFontOfSize:15];
        _statusLaebl.textAlignment = NSTextAlignmentRight;
        [_statusLaebl sizeToFit];
    }
    return _statusLaebl;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
