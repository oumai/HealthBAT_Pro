//
//  BATNewPayScueduleDayCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayScueduleDayCell.h"

@implementation BATNewPayScueduleDayCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self layoutPages];
    }
    return self;
}


- (void)layoutPages{
    
    WEAK_SELF(self);
    
    [self addSubview:self.timeLable];
    [self addSubview:self.leftImageIcon];
    [self addSubview:self.rightImageIcon];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.leftImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(self.frame.size.height);
        make.height.mas_equalTo(self.frame.size.height);
    }];
    
    [self.rightImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(self.frame.size.height);
        make.height.mas_equalTo(self.frame.size.height);
    }];
}

- (UILabel *)timeLable{
    
    if (!_timeLable) {
        _timeLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _timeLable.text = @"00:00-00:00";
    }
    
    return _timeLable;
}

- (UIImageView *)leftImageIcon{
    if (!_leftImageIcon) {
        _leftImageIcon = [[UIImageView alloc]init];
        _leftImageIcon.image = [UIImage imageNamed:@"back_icon"];
    }
    
    return _leftImageIcon;
}

- (UIView *)leftView{

    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.userInteractionEnabled = YES;
        [_leftView bk_whenTapped:^{
            if (self.clickLeftImageIcon) {
                self.clickLeftImageIcon();
            }
        }];
    }
    return _leftView;
}

- (UIView *)rightView{
    
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.userInteractionEnabled = YES;
        [_rightView bk_whenTapped:^{
            if (self.clickRightImageIcon) {
                self.clickRightImageIcon();
            }
        }];
    }
    return _rightView;
}

- (UIImageView *)rightImageIcon{
    if (!_rightImageIcon) {
        _rightImageIcon = [[UIImageView alloc]init];
        _rightImageIcon.image = [UIImage imageNamed:@"icon_arrow_right"];
        _rightImageIcon.userInteractionEnabled = YES;
        [_rightImageIcon bk_whenTapped:^{
            if (self.clickRightImageIcon) {
                self.clickRightImageIcon();
            }
        }];
    }
    
    return _rightImageIcon;
}


@end
