//
//  UIViewController+BATShowToast.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BATShowToast)

/**
 *  显示进度条（不消失）
 */
- (void)showProgress;

/**
 *  显示进度条（不消失）
 *
 *  @param progress 进度
 */
- (void)showProgres:(float)progress;

/**
 *  隐藏进度条
 */
- (void)dismissProgress;

/**
 *  只显示文字，自动消失
 *
 *  @param text 文字
 */
- (void)showText:(NSString *)text;

/**
 *  显示成功提示，自动消失
 *
 *  @param text 文字
 */
- (void)showSuccessWithText:(NSString *)text;

/**
 *  显示失败提示，自动消失
 *
 *  @param text 文字
 */
- (void)showErrorWithText:(NSString *)text;

/**
 *  显示进度条＋文字
 *
 *  @param text 文字
 */
- (void)showProgressWithText:(NSString *)text;


/**
 成功并执行block

 @param text 成功信息
 @param completion toast消失后执行block
 */
- (void)showSuccessWithText:(NSString *)text completion:(void (^)(void))completion;


/**
 失败提示并执行block

 @param text 失败信息
 @param completion toast消失后执行blcok
 */
- (void)showErrorWithText:(NSString *)text completion:(void (^)(void))completion;

/**
 *  只显示文字，自动消失
 *
 *  @param text 文字
 *  @param interval 时间
 */
- (void)showText:(NSString *)text withInterval:(NSTimeInterval)interval;

@end
