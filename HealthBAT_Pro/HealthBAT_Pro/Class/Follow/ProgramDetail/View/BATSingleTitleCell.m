//
//  BATSingleTitleCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSingleTitleCell.h"

@implementation BATSingleTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.textColor = STRING_DARK_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
