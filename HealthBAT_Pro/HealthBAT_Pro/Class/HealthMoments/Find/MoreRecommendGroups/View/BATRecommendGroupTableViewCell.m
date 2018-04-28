//
//  BATRecommendGroupTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRecommendGroupTableViewCell.h"

@implementation BATRecommendGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _groupIconImageView.layer.cornerRadius = _groupIconImageView.frame.size.height / 2;
    _groupIconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
