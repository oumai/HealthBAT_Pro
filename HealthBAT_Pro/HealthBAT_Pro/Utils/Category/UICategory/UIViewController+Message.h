//
//  UIViewController+Message.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

//代码.h文件
#import <UIKit/UIKit.h>

@interface UIViewController (Message)

/**
 弹出UIAlertController
 
 @param title  标题
 @param message 消息
 @param sure    点击确定按钮
 */
- (void)showAlertSureWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure;

/**
 弹出UIAlerController
 
 @param title  标题
 @param message 消息
 @param sure    点击确定
 @param cancel  点击取消
 */
- (void)showAlertSureAndCancelWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure cancel:(void (^) (UIAlertAction *action))cancel;

/**
 弹出UIAlertController
 
 @param actionOneTitle 标题
 @param handlerOne    点击标题的事件
 */
- (void)showSheetOneaction:(NSString *)actionOneTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne;

/**
 弹出UIAlerController
 
 @param actionOneTitle 第一标题
 @param actionTwoTitle 第二个标题
 @param handlerOne    第一个标题点击事件
 @param handlerTwo    第二个标题点击事件
 */
- (void)showSheetTwoaction:(NSString *)actionOneTitle actionTwo:(NSString *)actionTwoTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne handlerTwo:(void (^) (UIAlertAction *action))handlerTwo;


@end
