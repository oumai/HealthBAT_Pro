//
//  UserInfoView.h
//  HealthBAT
//
//  Created by KM on 16/6/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPerson.h"

@protocol BATUserInfoViewDelegate <NSObject>

@optional

- (void)showAvatorAction;

- (void)goLoginAction;

- (void)goUserInfoAction;

- (void)goMessageCenterAction;

@end

@interface BATUserInfoView : UIImageView

/**
 *  背景图
 */
@property (nonatomic,strong) UIImageView *bgView;

/**
 *  右箭头（铅笔按钮）
 */
@property (nonatomic,strong) UIImageView *pencilImage;

/**
 *  铃铛
 */
//@property (nonatomic,strong) UIImageView *messageImage;
@property (nonatomic,strong) UIButton   *messageButton;

/**
 *  个人信息按钮
 */
@property (nonatomic,strong) UIButton *userInfoBtn;

/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *avatorImageView;

/**
 *  等级
 */
@property (nonatomic,strong) UIImageView *masterView;

/**
 *  昵称
 */
@property (nonatomic,strong) UILabel *nickNameLabel;

/**
 *  个性签名
 */
@property (nonatomic,strong) UILabel *signatureLabel;

/**
 *  登录
 */
@property (nonatomic,strong) UIButton * loginButton;



/**
 *  委托
 */
@property (nonatomic,weak) id<BATUserInfoViewDelegate> delegate;

- (void)configureWithModel:(BATPerson *)person;

@end
