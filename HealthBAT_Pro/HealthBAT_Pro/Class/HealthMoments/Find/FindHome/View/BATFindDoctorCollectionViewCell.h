//
//  BATFindDoctorCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFindDoctorCollectionViewCell : UICollectionViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  UserName
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *followButton;

/**
 *  等级
 */
@property (weak, nonatomic) IBOutlet UIImageView *masterImageView;
@end
