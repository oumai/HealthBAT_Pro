//
//  BATHomeHospitalRegisterView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHospitalRegisterView.h"

@implementation BATHomeHospitalRegisterView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
        }];
        
        [self addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.width.mas_offset(40);
            make.height.mas_offset(50);
            make.centerX.equalTo(self.mas_right).offset(-40);
        }];
        
        [self addSubview:self.descripLabel];
        [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            if (iPhone5) {
                make.width.mas_offset(SCREEN_WIDTH *0.5 - 30 - 15);
            }else if(iPhone6){
                make.width.mas_offset(SCREEN_WIDTH *0.5 - 45 - 15);
            }else{
                make.width.mas_offset(SCREEN_WIDTH *0.5 - 45 - 20);
            }
        }];
        
//        [self addSubview:self.hotLabel];
//        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.top.equalTo(self.rightImageView);
//            make.width.height.mas_equalTo(16);
//        }];
        
//        [self setLeftBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:0.5 height:205/3.0];
//        [self setTopBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH*0.5 height:0.5];
//        [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH*0.5 height:0.5];
    }
    return self;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
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

- (UIImageView *)rightImageView {

    if (!_rightImageView) {
        _rightImageView  = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

//- (UILabel *)hotLabel {
//
//    if (!_hotLabel) {
//        _hotLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:9] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
//        _hotLabel.text = @"热";
//        _hotLabel.layer.cornerRadius = 8.0f;
//        _hotLabel.backgroundColor = [UIColor redColor];
//        _hotLabel.clipsToBounds = YES;
//        _hotLabel.hidden = YES;
//    }
//    return _hotLabel;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
