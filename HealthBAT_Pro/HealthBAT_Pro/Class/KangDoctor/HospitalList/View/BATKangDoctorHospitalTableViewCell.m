//
//  BATKangDoctorHospitalTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATKangDoctorHospitalTableViewCell.h"

@implementation BATKangDoctorHospitalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.hospitalImageView];
        [self.hospitalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.contentView addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.bottom.equalTo(@-5);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        [self.contentView addSubview:self.hospitalNameLabel];
        [self.hospitalNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.equalTo(@10);
            make.right.equalTo(@-110);
        }];
        
        
        [self.contentView addSubview:self.hospitalLocationLabel];
        [self.hospitalLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalImageView.mas_right).offset(10);
            make.top.greaterThanOrEqualTo(self.hospitalNameLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.right.equalTo(@-110);
        }];
        
        

    }
    return self;
}

#pragma mark -
- (UIImageView *)hospitalImageView {
    if (!_hospitalImageView) {
        _hospitalImageView = [[UIImageView alloc] init];

    }
    return _hospitalImageView;
}

- (UILabel *)hospitalNameLabel {
    if (!_hospitalNameLabel) {
        _hospitalNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _hospitalNameLabel.numberOfLines = 0;
        _hospitalNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _hospitalNameLabel;
}

- (UILabel *)hospitalLocationLabel {
    if (!_hospitalLocationLabel) {
        _hospitalLocationLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        _hospitalLocationLabel.numberOfLines = 0;
        _hospitalLocationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _hospitalLocationLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
        _distanceLabel.numberOfLines = 0;
        _distanceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _distanceLabel;
}


#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
