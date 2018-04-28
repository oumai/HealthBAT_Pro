//
//  BATRecommendGroupTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATRecommendGroupTableViewCell : UITableViewCell

/**
 *  群组ICON
 */
@property (weak, nonatomic) IBOutlet UIImageView *groupIconImageView;

/**
 *  群组名称
 */
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

/**
 *  群组成员
 */
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;

/**
 *  群组描述
 */
@property (weak, nonatomic) IBOutlet UILabel *groupDescLabel;

/**
 *  加入群组
 */
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;

@end
