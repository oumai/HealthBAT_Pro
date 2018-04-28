//
//  BATCheckDetailViewController.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATCheckDetailViewController : UIViewController

@property (nonatomic,strong) NSString *RecipeFileUrl;

/**
 预约id
 */
@property (nonatomic, copy) NSString *OPDRegisterID;

/**
 处方编号
 */
@property (nonatomic, copy) NSString *RecipeNo;

///**
// 处方ID
// */
//@property (nonatomic, copy) NSString *RecipeFileID;

///**
// 处方名称
// */
//@property (nonatomic, copy) NSString *RecipeName;
//
///**
// 金额
// */
//@property (nonatomic, copy) NSString *Amount;
//
///**
// 代煎费用单价 元/剂
// */
//@property (nonatomic, copy) NSString *ReplacePrice;
//
///**
// 判断是否代煎 0 否，非0是代煎
// */
//@property (nonatomic, assign) NSInteger ReplaceDose;
//
///**
// 一共多少剂
// */
//@property (nonatomic, assign) NSInteger TCMQuantity;

@end
