//
//  BATCallView.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATNetworkStateView.h"
#import "BATCallOptButton.h"
#import "BATWaterLine.h"

@interface BATCallView : UIView

/**
 背景
 */
@property (nonatomic,strong) UIImageView *bgView;

/**
 头像背景
 */
@property (nonatomic,strong) UIImageView *avatarImageView;

/**
 头像
 */
@property (nonatomic,strong) UIView *avatarBgView;

/**
 用户名
 */
@property (nonatomic,strong) UILabel *nameLabel;

/**
 呼叫状态
 */
@property (nonatomic,strong) UILabel *callStateLabel;


/**
 医生级别
 */
@property (nonatomic,strong) UILabel *doctorTitleLabel;


/**
 医院
 */
@property (nonatomic,strong) UILabel *hospitalAndDepartmentLabel;

/**
 计时
 */
@property (nonatomic,strong) UILabel *timeLabel;

/**
 网络状态
 */
//@property (nonatomic,strong) BATNetworkStateView *networkStateView;

/**
 波浪线
 */
@property (nonatomic,strong) BATWaterLine *waterLine;

/**
 取消
 */
@property (nonatomic,strong) BATCallOptButton *cancelButton;

/**
 挂断
 */
@property (nonatomic,strong) BATCallOptButton *hangUpButton;

/**
 接听
 */
@property (nonatomic,strong) BATCallOptButton *answerButton;

@end
