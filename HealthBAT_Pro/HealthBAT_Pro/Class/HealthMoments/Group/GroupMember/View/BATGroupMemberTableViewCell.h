//
//  BATGroupMemberTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  关注操作
 *
 *  @param model model数据
 */
typedef void(^FollowUser)(void);

@interface BATGroupMemberTableViewCell : UITableViewCell

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  等级
 */
@property (weak, nonatomic) IBOutlet UIImageView *masterImageView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

/**
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

/**
 *  关注
 */
@property (weak, nonatomic) IBOutlet UIButton *followButton;

/**
 *  关注操作block
 */
@property (nonatomic,strong) FollowUser followUser;

/**
 *  指定行
 */
@property (nonatomic,assign) NSIndexPath *indexPath;

- (void)configrationCell:(id)model;

@end
