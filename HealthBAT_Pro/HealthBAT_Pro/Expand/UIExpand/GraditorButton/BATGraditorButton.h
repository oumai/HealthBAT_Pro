//
//  BATGraditorButton.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCustomButton.h"

@interface BATGraditorButton : BATCustomButton
//设置字体颜色
@property (nonatomic,strong) UIColor *titleColor;
//是否需要镂空
@property(nonatomic,assign) BOOL enablehollowOut;
//是否需要渐变层
@property(nonatomic,assign) BOOL enbleGraditor;
//背景色
@property(nonatomic,strong) UIColor *customColor;
//圆角
@property (nonatomic,assign) CGFloat customCornerRadius;
//是否去除边框（镂空情况）
@property (nonatomic,assign) BOOL isDeleteBorder;

- (void)setGradientColors:(NSArray<UIColor *> *)colors;
@end
