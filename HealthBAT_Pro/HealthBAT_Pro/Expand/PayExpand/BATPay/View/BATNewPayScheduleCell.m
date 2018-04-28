//
//  BATNewPayScheduleCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayScheduleCell.h"

@implementation BATNewPayScheduleCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        [self setTopBorderWithColor:BASE_LINECOLOR width:self.frame.size.width height:0.5];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:self.frame.size.width height:0.5];
        [self setLeftBorderWithColor:BASE_LINECOLOR width:0.5 height:45];
//        [self setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:45];
        
        [self layoutPages];
    }
    return self;
}


- (void)layoutPages{
    
    WEAK_SELF(self);
    
    [self addSubview:self.timeLable];
    [self addSubview:self.fullImageIcon];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.fullImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.right.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (UILabel *)timeLable{
    
    if (!_timeLable) {
        _timeLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentCenter];
        _timeLable.text = @"00:00-00:00";
    }

    return _timeLable;
}

- (UIImageView *)fullImageIcon{
    if (!_fullImageIcon) {
        _fullImageIcon = [[UIImageView alloc]init];
        _fullImageIcon.image = [UIImage imageNamed:@"suchedule-full"];
        _fullImageIcon.hidden = YES;
    }
    
    return _fullImageIcon;
}

@end
