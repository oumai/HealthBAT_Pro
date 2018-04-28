//
//  BATPayViewController.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATConfirmPayView.h"

@interface BATPayViewController : UIViewController


/**
 *  view
 */
@property (nonatomic,strong) BATConfirmPayView *confirmPayView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) BATDoctorStudioOrderType type;

/**
 *  订单编号
 */
@property (nonatomic,strong) NSString *orderNo;

/**
 *  价格
 */
@property (nonatomic,strong) NSString  *momey;


@end
