//
//  BATCourseDetailAuthorCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseDetailModel.h"

typedef void(^FollowAction)(void);

@interface BATCourseDetailAuthorCell : UITableViewCell

/**
 头像
 */
@property (nonatomic,strong) UIImageView *avatarImageView;

/**
 用户名
 */
@property (nonatomic,strong) UILabel *usernameLabel;

/**
 个人签名
 */
@property (nonatomic,strong) UILabel *decsLabel;

/**
 关注按钮
 */
@property (nonatomic,strong) UIButton *followButton;

/**
 关注Block
 */
@property (nonatomic,strong) FollowAction followAction;

- (void)configData:(BATCourseDetailModel *)courseDetailModel;

@end
