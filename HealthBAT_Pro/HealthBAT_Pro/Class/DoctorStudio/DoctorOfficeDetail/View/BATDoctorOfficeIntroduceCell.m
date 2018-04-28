//
//  BATDoctorOfficeIntroduceCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorOfficeIntroduceCell.h"

@implementation BATDoctorOfficeIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.IntroduceLb.textColor = UIColorFromHEX(0X333333, 1);
    self.IntroduceContent.textColor = UIColorFromHEX(0X666666, 1);
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
