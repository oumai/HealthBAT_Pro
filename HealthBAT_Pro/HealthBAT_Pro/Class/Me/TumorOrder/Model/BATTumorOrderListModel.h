//
//  BATTumorOrderListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 OrderID = 4f480853-422b-48c3-920a-11d5b168f399,
	OrderCode = 10720170920100002,
	Prop3 = 15817468410,
	CreateDateTime = 2017-09-20 10:55:23,
	ProductName = 基础筛查套餐（男）,
	LinkUrl = https://ctms.anticancer365.com/BATExamine/package_man1.html,
	ProductID = 2c821730-9f54-4d25-8307-a8c30c265d9e,
	TotalFee = 0.01,
	OrderStatus = 1

 */

@interface BATTumorOrderListModel : NSObject
/** <#属性描述#> */
@property (nonatomic, strong) NSString *OrderID;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *OrderCode;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *CreateDateTime;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *LinkUrl;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *ProductName;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *ProductID;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *TotalFee;
/** <#属性描述#> */
@property (nonatomic, assign) NSInteger OrderStatus;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *Prop3;
@end
