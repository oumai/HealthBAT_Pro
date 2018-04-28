//
//  UIView+Border.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)
/**
 *  设置底部边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为width
 *  @param height 高度，传0默认为0.5
 */
- (void)setBottomBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置顶部边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为width
 *  @param height 高度，传0默认为0.5
 */
- (void)setTopBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置左边边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为0.5
 *  @param height 高度，传0默认为height
 */
- (void)setLeftBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置右边边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为0.5
 *  @param height 高度，传0默认为height
 */
- (void)setRightBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 设置底部边 左右可设置间隔

 @param color 颜色
 @param width 宽度，传0默认为0.5
 @param height 高度，传0默认为height
 @param left 左边间距
 @param right 右边间距
 */
- (void)setBottomBorderWithColor:(UIColor *)color width:(float)width height:(float)height leftOffset:(float)left rightOffset:(float)right;


@end
