//
//  BATTumorOrderListViewController.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, TumorOrderType)
{
    TumorOrderTypeAll = -1,
    TumorOrderTypeUnpaid,
    TumorOrderTypeAlreadyPaid,
    TumorOrderTypeFinsh,
    TumorOrderTypeCancel
    
} ;


@interface BATTumorOrderListViewController : UIViewController
/** <#属性说明#> */
@property (nonatomic, assign) TumorOrderType  OrderType;
@end
