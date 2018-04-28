//
//  BATDoctorOfficeHeadCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorOfficeHeadCell.h"

@implementation BATDoctorOfficeHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLb.textColor = UIColorFromHEX(0X333333, 1);
    self.hosptialLb.textColor = UIColorFromHEX(0X666666, 1);
    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 30;
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.nameLb.text = @"";
    self.hosptialLb.text = @"";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
