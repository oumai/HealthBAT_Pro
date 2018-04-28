//
//  BATMoreViewCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMoreViewCell.h"

@implementation BATMoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    self.titleLb.font = [UIFont systemFontOfSize:15];
    
    self.moreLb.textColor = UIColorFromHEX(0X666666, 1);
    self.moreLb.font = [UIFont systemFontOfSize:14];
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
