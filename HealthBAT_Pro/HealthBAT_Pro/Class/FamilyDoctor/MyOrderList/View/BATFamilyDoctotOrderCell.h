//
//  BATFamilyDoctotOrderCell.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATFamilyDoctorOrderModel.h"

#import "BATGraditorButton.h"

typedef NS_ENUM(NSInteger,FamilyDoctorOrderState) {
    FamilyDoctorOrderStateBuy = 0,
    FamilyDoctorOrderStateCancel = 1,
};

@interface BATFamilyDoctotOrderCell : UITableViewCell

/*
 背景
 */
@property (nonatomic,strong) UIView     *bgView;
/*
 咨询按钮：开始咨询
 */
//@property (nonatomic,strong) UIButton   *consultButton;
@property (nonatomic,strong) BATGraditorButton   *consultButton;

/*
 上门服务按钮
 */
//@property (nonatomic,strong) UIButton   *goHomeButton;
@property (nonatomic,strong) BATGraditorButton   *goHomeButton;
/*
 服务状态
 */
@property (nonatomic,strong) UILabel    *serviceStateLabel;
/*
 线
 */
@property (nonatomic,strong) UIView     *midLine;
/*
 咨询套餐
 */
@property (nonatomic,strong) UILabel    *consultService;
/*
 套餐内容
 */
@property (nonatomic,strong) UILabel    *consultServiceCostLabel;
/*
 服务时间
 */
@property (nonatomic,strong) UILabel    *serviceIntervalLabel;
/*
 具体时间区间
 */
@property (nonatomic,strong) UILabel    *serviceIntervalTimeLabel;
/*
 订单icon
 */
@property (nonatomic,strong) UIImageView     *iconImageView;
/*
 发送请求时间
 */
@property (nonatomic,strong) UILabel     *requestTimeLabel;
/*
 线
 */
@property (nonatomic,strong) UIView     *bottomLine;
/*
 附件合同
 */
@property (nonatomic,strong) UIButton   *contractDetailButton;
/*
 取消按钮（全部列表中才显示）
 */
@property (nonatomic,strong) UIButton   *cancelOrderButton;
/*
 请求按钮:可能是取消订、支付（优先显示这个按钮）、评价
 */
@property (nonatomic,strong) UIButton   *requestBtn;

@property (nonatomic,copy)   void(^consultBtnClickBlock)(void);

@property (nonatomic,copy)   void(^goHomeBtnClickBlock)(void);

@property (nonatomic,copy)   void(^contractDetailBtnClickBlock)(void);

@property (nonatomic,copy)   void(^cancelOrderBtnClickBlock)(void);

@property (nonatomic,copy)   void(^requestBtnClickBlock)(void);

/*
 根据订单类型，显示不同的按钮
 */
@property (nonatomic,assign) BOOL isShowConsultBtn;
@property (nonatomic,assign) BOOL isShowGoHomeBtn;

- (void)cellWithData:(BATFamilyDoctorOrderData *)data;

@end
