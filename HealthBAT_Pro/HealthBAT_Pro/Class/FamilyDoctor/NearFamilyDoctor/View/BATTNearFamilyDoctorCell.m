//
//  BATTNearFamilyDoctorCell.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTNearFamilyDoctorCell.h"

@implementation BATTNearFamilyDoctorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@10);
            make.left.equalTo(self.mas_left).offset(12);
            make.height.mas_equalTo(60).priorityHigh();
            make.width.mas_equalTo(60);
            make.bottom.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(@15);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
        }];
        
        [self.contentView addSubview:self.hosptialLable];
        [self.hosptialLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLable.mas_bottom).offset(12);
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        
        [self.contentView addSubview:self.departmentLable];
        [self.departmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.nameLable.mas_centerY);
            make.left.equalTo(self.nameLable.mas_right).offset(30);
        }];
        
        [self.contentView addSubview:self.distanceLable];
        [self.distanceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.nameLable.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.25f];
    }
    
    return self;
}


- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headerImageView.layer.cornerRadius = 30.f;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.opaque = YES;
        _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerImageView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [_nameLable sizeToFit];
    }
    
    return _nameLable;
}

- (UILabel *)hosptialLable{
    if (!_hosptialLable) {
        _hosptialLable = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        [_hosptialLable sizeToFit];
//        _hosptialLable.numberOfLines = 0;
    }
    
    return _hosptialLable;
}


- (UILabel *)departmentLable{
    if (!_departmentLable) {
        _departmentLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        [_departmentLable sizeToFit];
    }
    
    return _departmentLable;
}

- (UILabel *)distanceLable{
    if (!_distanceLable) {
        _distanceLable = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _distanceLable.hidden = YES;
        [_distanceLable sizeToFit];
    }
    
    return _distanceLable;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
