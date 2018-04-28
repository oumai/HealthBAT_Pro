//
//  BATHealthThreeSecondsTopChangeDateView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATHealthThreeSecondsTopChangeDateViewDelegate <NSObject>
@optional

- (void)leftButtonDidClick:(UIButton *)leftButton date:(NSString *)date;
- (void)rightButtonDidClick:(UIButton *)rightButton date:(NSString *)date;
- (void)centerButtonDidClick:(UIButton *)centerButton callBackBlock:(void (^)(NSString *date))callBackBlock;

@end

@interface BATHealthThreeSecondsTopChangeDateView : UIView

/** delegate属性 */
@property (nonatomic, weak) id  <BATHealthThreeSecondsTopChangeDateViewDelegate>delegate;
@property (nonatomic, copy) NSString *defauDateStr;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIButton *rightButton;

@end
