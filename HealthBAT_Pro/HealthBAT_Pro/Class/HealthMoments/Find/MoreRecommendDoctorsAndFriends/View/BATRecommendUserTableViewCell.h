//
//  BATRecommendUserTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  关注操作
 *
 *  @param model model数据
 */
typedef void(^FollowUser)(void);

@interface BATRecommendUserTableViewCell : UITableViewCell
/**
 *  底部灰线
 */
@property (nonatomic,strong)UIView *bottomView;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

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
