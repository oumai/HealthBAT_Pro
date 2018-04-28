//
//  UITabBar+BATTabbar.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (BATTabbar)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点


@end
