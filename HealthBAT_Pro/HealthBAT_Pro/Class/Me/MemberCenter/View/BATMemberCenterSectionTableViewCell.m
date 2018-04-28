//
//  BATMemberCenterSectionTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATMemberCenterSectionTableViewCell.h"

@implementation BATMemberCenterSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomBorderWithColor:LineColor width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
