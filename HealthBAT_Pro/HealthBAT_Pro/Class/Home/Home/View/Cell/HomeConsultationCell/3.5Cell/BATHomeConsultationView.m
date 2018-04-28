//
//  BATHomeConsultationView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeConsultationView.h"

@implementation BATHomeConsultationView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self).offset(12.5);
            make.top.equalTo(self).offset(14);
        }];
        
        [self addSubview:self.bottomImageView];
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.width.mas_offset(60);
            make.height.mas_offset(40);
            make.centerX.equalTo(self.mas_right).offset(-40);

        }];
        
        [self addSubview:self.descripLabel];
        [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(12.5);
//            make.right.equalTo(self.bottomImageView.mas_left).offset(-7);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        }];

//        [self setLeftBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:0.5 height:205/3.0];
//        [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH*0.5 height:0.5];
//        [self setTopBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH*0.5 height:0.5];
    }
    return self;
}

//- (UIImageView *)topImageView {
//
//    if (!_topImageView) {
//        _topImageView = [[UIImageView alloc] init];
//    }
//    return _topImageView;
//}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
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
//        _bottomImageView.backgroundColor = [UIColor redColor];
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
