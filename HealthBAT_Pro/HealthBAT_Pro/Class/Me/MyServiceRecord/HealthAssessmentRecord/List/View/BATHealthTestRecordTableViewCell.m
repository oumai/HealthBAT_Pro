//
//  BATHealthTestRecordTableViewCell.m
//  HealthBAT
//
//  Created by KM on 16/6/162016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthTestRecordTableViewCell.h"

@implementation BATHealthTestRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(BATHealthTestRecordData *)record {
    self.nameLabel.text = record.Theme;

    self.timeLabel.text = record.CreatedTime;
}

@end
