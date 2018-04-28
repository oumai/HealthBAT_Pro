//
//  BATCustomNormalTableViewCell.m
//  HealthBAT
//
//  Created by KM on 16/6/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCustomNormalTableViewCell.h"

@implementation BATCustomNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
