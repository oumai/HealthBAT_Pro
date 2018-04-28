//
//  BATHomeTodayOfferGoodView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTodayOfferGoodView.h"

@implementation BATHomeTodayOfferGoodView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);
    
        [self addSubview:self.clockImageView];
        [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
        }];
        
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.clockImageView.mas_right).offset(10);
            make.centerY.equalTo(self.clockImageView.mas_centerY).offset(0);
        }];
        
        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.bottom.equalTo(@-10);
            if (iPhone5) {
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(50);
            }if (iPhone6) {
                make.height.mas_equalTo(60);
                make.width.mas_equalTo(60);
            }else{
                make.height.mas_equalTo(70);
                make.width.mas_equalTo(70);
            }
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.clockImageView.mas_bottom).offset(10);
            make.right.equalTo(@0);
            make.left.equalTo(self.leftImageView.mas_right).offset(5);
        }];
        
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.nameLabel.mas_left).offset(0);
        }];
    
        [self bringSubviewToFront:self.clockImageView];
        [self bringSubviewToFront:self.timeLabel];
        
    }
    return self;
}

- (UIImageView *)clockImageView {
    
    if (!_clockImageView) {
        
        _clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jsq"]];
    }
    return _clockImageView;
}

- (MZTimerLabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[MZTimerLabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.timeLabel.textColor = STRING_MID_COLOR;
        _timeLabel.timeFormat = @"HH:mm:ss";
        _timeLabel.timerType = MZTimerLabelTypeTimer;
        _timeLabel.layer.cornerRadius = 3.0f;
        _timeLabel.clipsToBounds = YES;
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [_leftImageView sizeToFit];
    }
    return _leftImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0xff0707, 1) textAlignment:NSTextAlignmentLeft];
        _priceLabel.hidden = YES;
    }
    return _priceLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
