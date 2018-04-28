//
//  BATFamilyDoctorOrderDetailBottomView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFamilyDoctorOrderDetailBottomView : UIView

/*
 背景
 */
@property (nonatomic,strong) UIView     *bgView;
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

@property (nonatomic,copy)   void(^contractDetailBtnClickBlock)(void);

@property (nonatomic,copy)   void(^cancelOrderBtnClickBlock)(void);

@property (nonatomic,copy)   void(^requestBtnClickBlock)(void);

- (void)cellWithData:(BATFamilyDoctorOrderState )OrderStateShow isComment:(BOOL)isComment;
@end
