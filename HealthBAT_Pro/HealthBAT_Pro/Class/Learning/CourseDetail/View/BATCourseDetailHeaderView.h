//
//  BATCourseDetailHeaderView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseDetailModel.h"
#import "ZFPlayerView.h"
#import "BATGraditorButton.h"
typedef void(^FollowAction)(void);

@interface BATCourseDetailHeaderView : UIView

/**
 用户信息view
 */
@property (nonatomic,strong) UIView *userInfoView;

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
@property (nonatomic,strong) BATGraditorButton *followButton;

/**
 关注图片
 */
@property (nonatomic,strong) UIImageView *followimageView;

/**
 关注Block
 */
@property (nonatomic,strong) FollowAction followAction;

/**
 播放器父view
 */
@property (nonatomic,strong) UIView *fatherView;

/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView *playerView;

/**
 播放器操作View
 */
@property (nonatomic,strong) ZFPlayerControlView *controlView;

/**
 头像点击Block
 */
@property (nonatomic,copy) void(^avatarTap)(void);

- (void)configData:(BATCourseDetailModel *)courseDetailModel;

@end
