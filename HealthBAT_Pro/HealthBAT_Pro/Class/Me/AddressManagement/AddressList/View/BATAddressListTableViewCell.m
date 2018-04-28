//
//  BATAddressListTableViewCell.m
//  HealthBAT
//
//  Created by KM on 16/6/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressListTableViewCell.h"

@implementation BATAddressListTableViewCell

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
