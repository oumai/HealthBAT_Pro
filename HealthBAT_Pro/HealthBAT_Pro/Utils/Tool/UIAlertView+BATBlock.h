//
//  UIAlertView+BATBlock.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (BATBlock)<UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;


/**
 *  UIAlertView block 调用
 *
 *  @param alertViewCallBackBlock 回调
 *  @param title                  标题
 *  @param message                信息
 *  @param cancelButtonName       取消按钮
 *  @param otherButtonTitles      其他按钮
 */
+ (void)bat_alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
@end
