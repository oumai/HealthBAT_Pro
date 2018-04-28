//
//  BATMemberTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATMemberTableViewCell.h"

@implementation BATMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.avatorImageView.backgroundColor = [UIColor redColor];
    self.avatorImageView.layer.cornerRadius = 50 / 2;
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatorImageView.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
