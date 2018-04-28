//
//  BATAppDelegate+BATViewControllerSetting.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"

@interface BATAppDelegate (BATViewControllerSetting)

/**
 *  设置VC颜色等
 */
- (void)bat_settingVC;
/**
 *  VC消失时执行方法
 */
- (void)bat_VCDissmiss;

@end
