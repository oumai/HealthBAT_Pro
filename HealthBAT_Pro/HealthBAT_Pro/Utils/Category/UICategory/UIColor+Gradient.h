//
//  UIColor+Gradient.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Gradient)
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)startColor toColor:(UIColor*)endColor withHeight:(int)height;
@end

