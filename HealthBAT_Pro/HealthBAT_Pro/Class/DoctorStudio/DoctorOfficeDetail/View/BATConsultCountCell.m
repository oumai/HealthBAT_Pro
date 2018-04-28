//
//  BATConsultCountCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultCountCell.h"

@implementation BATConsultCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ConsultConuntLb.textColor = UIColorFromHEX(0X666666, 1);
    self.EvaluateLb.textColor = UIColorFromHEX(0X666666, 1);
    
    self.ConsultConuntTips.textColor = UIColorFromHEX(0X333333, 1);
    self.EvaluateTips.textColor = UIColorFromHEX(0X333333, 1);
    
    self.VerLineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.ConsultConuntLb.text = @"";
    self.EvaluateLb.text = @"";
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
