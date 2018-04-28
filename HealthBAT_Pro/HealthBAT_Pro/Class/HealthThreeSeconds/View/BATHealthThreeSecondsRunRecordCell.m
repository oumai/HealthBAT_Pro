//
//  BATHealthThreeSecondsRunningRecordCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsRunRecordCell.h"

@implementation BATHealthThreeSecondsRunRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.stepCountLabel.textColor = UIColorFromHEX(0x333333, 1);
    self.titleLabel.textColor = UIColorFromHEX(0x666666, 1);;
    self.calorieLabel.textColor = UIColorFromHEX(0x666666, 1);;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
