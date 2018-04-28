//
//  BATCustomTextViewTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCustomTextViewTableViewCell.h"

@implementation BATCustomTextViewTableViewCell

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
