//
//  BATHomeNationalPhysicianPavilionView.m
//  HealthBAT_Pro
//
//  Created by four on 16/11/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNationalPhysicianPavilionView.h"

@implementation BATHomeNationalPhysicianPavilionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.equalTo(self).offset(12.5);
        }];
        
        [self addSubview:self.bottomImageView];
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
//            make.top.equalTo(self.mas_top).offset(15);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
//            make.width.mas_offset(SCREEN_WIDTH/5.0);
//            make.height.mas_offset(SCREEN_WIDTH/5.0*0.34*208/279);
            [self.bottomImageView sizeToFit];
        }];
        
        [self addSubview:self.descripLabel];
        [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(12.5);
            make.top.equalTo(self.topImageView.mas_bottom).offset(5);
            make.width.mas_offset(SCREEN_WIDTH*0.34 - 20);
        }];
    
//        [self setRightBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:0.25 height:186/2.0];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH*0.5 height:0.5];
    }
    return self;
}


- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}

- (UILabel *)descripLabel {
    
    if (!_descripLabel) {
        _descripLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _descripLabel.numberOfLines = 0;
    }
    return _descripLabel;
}

- (UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
    }
    return _bottomImageView;
}


@end
