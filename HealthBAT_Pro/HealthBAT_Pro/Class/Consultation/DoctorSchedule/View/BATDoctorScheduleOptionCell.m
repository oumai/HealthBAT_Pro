//
//  BATDoctorScheduleOptionCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleOptionCell.h"

@implementation BATDoctorScheduleOptionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        _borderView = [[UIView alloc] init];
//        _borderView.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
//        _borderView.hidden = YES;
//        [self.contentView addSubview:_borderView];
//        
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor whiteColor];
//        _titleLabel.textColor = UIColorFromHEX(0x45a0f0, 1);
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont systemFontOfSize:14];
////        _titleLabel.layer.borderColor = UIColorFromHEX(0x45a0f0, 1).CGColor;
////        _titleLabel.layer.borderWidth = 0.5f;
//        [self.contentView addSubview:_titleLabel];
        
        
        
        _chooseImageView = [[UIImageView alloc]init];
        _chooseImageView.image = [UIImage imageNamed:@"schedule-sle"];
        _chooseImageView.hidden = YES;
        [self.contentView addSubview:_chooseImageView];
        
        _unChooseImageView = [[UIImageView alloc]init];
        _unChooseImageView.image = [UIImage imageNamed:@"schedule-unsle"];
        _unChooseImageView.hidden = YES;
        [self.contentView addSubview:_unChooseImageView];
        
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupConstraints
{
    
    WEAK_SELF(self);
//    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(-1, -1, -1, -1));
//    }];
//    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.edges.equalTo(self);
//    }];
    
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [_unChooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (![_regNumList.DoctorScheduleID isEqualToString:@"0"]) {
        if (self.selected) {
            _chooseImageView.hidden = NO;
            _unChooseImageView.hidden = YES;
//            _titleLabel.textColor = [UIColor whiteColor];
//            _titleLabel.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
        } else {
            _chooseImageView.hidden = YES;
            _unChooseImageView.hidden = NO;
//            _titleLabel.textColor = UIColorFromHEX(0x45a0f0, 1);
//            _titleLabel.backgroundColor = [UIColor whiteColor];
        }
    }
    

}

@end
