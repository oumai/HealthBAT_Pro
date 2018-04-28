//
//  BATExecutePointsTitleTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATExecutePointsTitleTableViewCell.h"

@implementation BATExecutePointsTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = STRING_DARK_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
