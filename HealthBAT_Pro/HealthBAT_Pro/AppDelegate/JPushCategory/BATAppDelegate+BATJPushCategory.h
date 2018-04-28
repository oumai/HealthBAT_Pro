//
//  BATAppDelegate+BATJPushCategory.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


@interface BATAppDelegate (BATJPushCategory)<JPUSHRegisterDelegate, UIAlertViewDelegate>

- (void)bat_registerAPNS;

- (void)bat_registerJPush:(NSDictionary *)launchOptions;

- (void)bat_getLocalNotification:(NSDictionary *)launchOptions;

- (void)setHealthThreeSecondLocalNotificationInfo;
@end
