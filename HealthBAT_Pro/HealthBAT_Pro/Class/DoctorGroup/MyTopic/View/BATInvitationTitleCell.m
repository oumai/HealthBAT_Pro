//
//  BATInvitationTitleCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationTitleCell.h"

@implementation BATInvitationTitleCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    self.titleLb.font = [UIFont systemFontOfSize:18];
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
}

@end
