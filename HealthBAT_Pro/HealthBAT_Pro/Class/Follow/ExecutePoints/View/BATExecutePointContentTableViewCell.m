//
//  BATExecutePointContentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATExecutePointContentTableViewCell.h"

@implementation BATExecutePointContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.textColor = STRING_MID_COLOR;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
