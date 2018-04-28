//
//  BATFindDoctorCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindDoctorCollectionViewCell.h"

@implementation BATFindDoctorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _masterImageView.hidden = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 5.0;
    _followButton.layer.borderColor = BASE_COLOR.CGColor;
    _followButton.layer.borderWidth = 1.0;
    
}

@end
