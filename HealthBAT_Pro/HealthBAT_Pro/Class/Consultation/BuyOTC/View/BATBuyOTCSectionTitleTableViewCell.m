//
//  BATBuyOTCSectionTitleTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBuyOTCSectionTitleTableViewCell.h"

@implementation BATBuyOTCSectionTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
