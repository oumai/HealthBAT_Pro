//
//  BATUserPersonCenterUserInfoView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATUserPersonCenterUserInfoView;
@protocol BATUserPersonCenterUserInfoViewDelegate <NSObject>

@optional
/**
 *  关注操作按钮点击
 *
 *  @param userPersonCenterUserInfoView 个人信息view
 *  @param button                       关注操作按钮
 */
- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView followButtonClicked:(UIButton *)button;

/**
 *  咨询操作按钮点击
 *
 *  @param userPersonCenterUserInfoView 个人信息view
 *  @param button                       咨询操作按钮
 */
- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView consulationButtonClicked:(UIButton *)button;

/**
 *  关注成员按钮点击
 *
 *  @param userPersonCenterUserInfoView 个人信息view
 *  @param button                       关注成员按钮
 */
- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView followMemberButtonClicked:(UIButton *)button;

/**
 *  粉丝成员按钮点击
 *
 *  @param userPersonCenterUserInfoView 个人信息view
 *  @param button                       粉丝成员按钮
 */
- (void)BATUserPersonCenterUserInfoView:(BATUserPersonCenterUserInfoView *)userPersonCenterUserInfoView fansMemberButtonClicked:(UIButton *)button;

@end

@interface BATUserPersonCenterUserInfoView : UIView

/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *avatarImageView;

/**
 *  等级
 */
@property (nonatomic,strong) UIImageView *masterImageView;

/**
 *  用户名
 */
@property (nonatomic,strong) UILabel *userNameLabel;

/**
 *  个性签名
 */
@property (nonatomic,strong) UILabel *signatureLabel;

/**
 *  性别
 */
@property (nonatomic,strong) UIImageView *sexImageView;

/**
 *  工具view - 放关注，粉丝按钮
 */
@property (nonatomic,strong) UIView *toolView;

/**
 *  关注操作按钮
 */
@property (nonatomic,strong) UIButton *followButton;

/**
 *  咨询按钮
 */
@property (nonatomic,strong) UIButton *consulationButton;

/**
 *  关注成员数量按钮
 */
@property (nonatomic,strong) UIButton *followMemberButton;

/**
 *  粉丝成员数量按钮
 */
@property (nonatomic,strong) UIButton *fansMemberButton;

/**
 *  委托
 */
@property (nonatomic, weak) id<BATUserPersonCenterUserInfoViewDelegate> delegate;

/**
 *  配置加载数据
 *
 *  @param model 个人信息数据
 */
- (void)configrationUserInfo:(id)model;

@end
