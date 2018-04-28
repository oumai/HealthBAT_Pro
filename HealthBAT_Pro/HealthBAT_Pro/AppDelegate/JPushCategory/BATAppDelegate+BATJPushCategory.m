//
//  BATAppDelegate+BATJPushCategory.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATJPushCategory.h"

#import "BATPushModel.h"

#import "BATMessageViewController.h"
#import "BATProgramDetailViewController.h"
#import "BATHealthThreeSecondsController.h"
#import "BATClockManager.h"
#import "BATLoginViewController.h"
@implementation BATAppDelegate (BATJPushCategory)
/*
  0     成功
 1005	AppKey不存在
 1008	AppKey非法	请到官网检查此应用详情中的appkey，确认无误
 1009	当前appkey无对应应用	当前的appkey下没有创建iOS应用。请到官网检查此应用的应用详情
 6001	无效的设置，tag/alias 不应参数都为 null
 6002	设置超时	建议重试
 6003	alias 字符串不合法	有效的别名组成：字母（区分大小写）、数字、下划线、汉字，特殊字符(v2.1.9支持)@!#$&*+=.|
 6004	alias超长。最多 40个字节	中文 UTF-8 是 3 个字节
 6005	某一个 tag 字符串不合法	有效的标签组成：字母（区分大小写）、数字、下划线、汉字，特殊字符(v2.1.9支持)@!#$&*+=.|
 6006	某一个 tag 超长。一个 tag 最多 40个字节	中文 UTF-8 是 3 个字节
 6007	tags 数量超出限制。最多 1000个	这是一台设备的限制。一个应用全局的标签数量无限制。
 6008	tag 超出总长度限制	总长度最多 7K 字节
 6011	10s内设置tag或alias大于10次	短时间内操作过于频繁
 */
- (void)bat_registerAPNS{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    extern NSString *const kJPFNetworkFailedRegisterNotification; //注册失败

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPRegisterFailed:) name:@"kJPFNetworkFailedRegisterNotification" object:nil];
}

- (void)JPRegisterFailed:(NSNotification *)noti {

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:noti.userInfo];
    [dic setObject:@"极光注册失败" forKey:@"Action"];

    BOOL isWriteSuccess = [Tools errorWriteLocationWithData:dic];
    if (isWriteSuccess) {
        DDLogDebug(@"写入成功");
    }
}

- (void)bat_registerJPush:(NSDictionary *)launchOptions{
    
    NSString *appKey;
    NSInteger isProduction;
#ifdef DEBUG
    //AppStore开发 com.KmHealthBAT.app
    appKey = @"a5bc319c500d8815defafa55";
    isProduction = 0;
#elif TESTING
    //AppStore测试 com.KmHealthBAT.app
    appKey = @"a5bc319c500d8815defafa55";
    isProduction = 0;
#elif PUBLICRELEASE
    //企业版开发 com.KmHealthBAT.Enterprise.app
    appKey = @"404b42e6bd18b260bb8cbee9";
    isProduction = 0;
#elif PRERELEASE
    //企业版发布 com.KmHealthBAT.Enterprise.app
    appKey = @"a5bc319c500d8815defafa55";
    isProduction = 1;
#elif ENTERPRISERELEASE
    //企业版发布 com.KmHealthBAT.Enterprise.app
    appKey = @"404b42e6bd18b260bb8cbee9";
    isProduction = 1;
#elif RELEASE
    //AppStore发布 com.KmHealthBAT.app
    appKey = @"a5bc319c500d8815defafa55";
    isProduction = 1;
#endif
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
}


#pragma mark - 极光推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    //融云注册token
    [[BATRongCloudManager sharedBATRongCloudManager] bat_rongCloudRegistDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);

    NSDictionary *dic = @{
                          @"Action":@"DeviceToken Failed",
                          @"Description":error.description,
                          @"Code":[NSString stringWithFormat:@"%ld",(long)error.code],
                          };
    BOOL isWriteSuccess = [Tools errorWriteLocationWithData:dic];
    if (isWriteSuccess) {
        DDLogDebug(@"写入成功");
    }
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support  前台接受
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程推送
        
        BATPushModel *model = [BATPushModel mj_objectWithKeyValues:notification.request.content.userInfo];
        
        if (model.JPushMsgType == BATJPushMsgTypeDoctor) {
            //医生工作室的消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOCTOR_STUDIO_APNS_RELOAD" object:nil];
        }
        else if (model.JPushMsgType == BATJPushMsgTypePatient) {
            //患者的消息
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
            //首页角标变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE" object:nil];
            //消息中心角标变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE_RELOAD" object:nil];
        }
        
    } else {
        // 判断为本地通知
        if ([notification.request.identifier isEqualToString:@"BATHealthThreeSecondKey"]) {
            [self setHealthThreeSecondLocalNotificationInfo];
        } else {
            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
        }
    }
}

// iOS 10 Support 后台接受
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
   
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 后台接受 收到远程通知");
        
        BATPushModel *model = [BATPushModel mj_objectWithKeyValues:userInfo];
        
        if (model.JPushMsgType == BATJPushMsgTypeDoctor) {
            //医生工作室的消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOCTOR_STUDIO_APNS_RELOAD" object:nil];

        }
        else if (model.JPushMsgType == BATJPushMsgTypePatient) {
            //患者的消息
            
            if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
                //前台：消息+1
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
                //消息中心角标变化
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE_RELOAD" object:nil];
                
            }else {
                //后台：回到首页发送通知，推出消息中心
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
                
                BATRootTabBarController *rootTabBar = (BATRootTabBarController *)self.window.rootViewController;
                [rootTabBar setSelectedIndex:0];
                //直接PUSH消息中心
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_PUSH_MESSAGE_VC" object:nil];
            }
        }
    }
    else {
        // 判断为本地通知
        if ([[userInfo valueForKey:BATHealthThreeSecondKey] isEqualToString:@"BATHealthThreeSecondKey"]) {
            [self setHealthThreeSecondLocalNotificationInfo];
            if (!LOGIN_STATION) {
                [[Tools getCurrentVC] presentViewController:[[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]] animated:YES completion:nil];
            } else {
                [BATClockManager shared].isPopHealthThreeSecondVC = NO;
                [BATClockManager shared].healthThreeSecondVC = nil;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否进入健康3秒钟界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                for (UIViewController *vc in [Tools getCurrentVC].navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[BATHealthThreeSecondsController class]]) {
                        if ([vc isEqual:[Tools getCurrentVC].navigationController.childViewControllers.lastObject]) {
                            [[Tools getCurrentVC].navigationController popToViewController:vc animated:NO];
                        } else {
                            [BATClockManager shared].isPopHealthThreeSecondVC = YES;
                            [BATClockManager shared].healthThreeSecondVC = vc;
                            [alertView show];
                        }
                    }else {
                        if([vc isEqual:[Tools getCurrentVC].navigationController.childViewControllers.lastObject]){
                            [alertView show];
                        }
                    }
                }
            }
        } else {
            DDLogDebug(@"测试2");
            NSArray *array = [response.notification.request.identifier componentsSeparatedByString:@"_"];
            [self pushProgramVC:[array[1] integerValue]];
        }
    }
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    BATPushModel *model = [BATPushModel mj_objectWithKeyValues:userInfo];

    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        
        
        if (model.JPushMsgType == BATJPushMsgTypeDoctor) {
            //医生工作室的消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOCTOR_STUDIO_APNS_RELOAD" object:nil];
        }
        else if (model.JPushMsgType == BATJPushMsgTypePatient) {
            //患者的消息
            
            //前台：消息+1
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
            //消息中心角标变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE_RELOAD" object:nil];
            //首页角标变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE" object:nil];
        }
    }else {
        
        if (model.JPushMsgType == BATJPushMsgTypeDoctor) {
            //医生工作室的消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOCTOR_STUDIO_APNS_RELOAD" object:nil];
        }
        else if (model.JPushMsgType == BATJPushMsgTypePatient) {
            //患者的消息
            
            //后台：回到首页发送通知，推出消息中心
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
            
            BATRootTabBarController *rootTabBar = (BATRootTabBarController *)self.window.rootViewController;
            [rootTabBar setSelectedIndex:0];
            
            //直接PUSH消息中心
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_PUSH_MESSAGE_VC" object:nil];
        }
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //本地通知
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
//    NSDictionary *userInfo = notification.userInfo;
//    NSArray *array = [[userInfo objectForKey:@"identifier"] componentsSeparatedByString:@"_"];
//    [self pushProgramVC:[array[1] integerValue]];
    
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo valueForKey:BATHealthThreeSecondKey] isEqualToString:@"BATHealthThreeSecondKey"]) {
        [self setHealthThreeSecondLocalNotificationInfo];
        if (!LOGIN_STATION) {
            [[Tools getCurrentVC] presentViewController:[[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]] animated:YES completion:nil];
        } else {
            [BATClockManager shared].isPopHealthThreeSecondVC = NO;
            [BATClockManager shared].healthThreeSecondVC = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否进入健康3秒钟界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            for (UIViewController *vc in [Tools getCurrentVC].navigationController.childViewControllers) {
                if ([vc isKindOfClass:[BATHealthThreeSecondsController class]]) {
                    if ([vc isEqual:[Tools getCurrentVC].navigationController.childViewControllers.lastObject]) {
                        [[Tools getCurrentVC].navigationController popToViewController:vc animated:NO];
                    } else {
                        [BATClockManager shared].isPopHealthThreeSecondVC = YES;
                        [BATClockManager shared].healthThreeSecondVC = vc;
                        [alertView show];
                    }
                }else {
                    if([vc isEqual:[Tools getCurrentVC].navigationController.childViewControllers.lastObject]){
                        [alertView show];
                    }
                }
            }
        }
    }else {
        NSString *title = userInfo[@"title"];
        NSString *body = userInfo[@"body"];
        
        NSString *message = @"";
        if (body.length <= 0) {
            message = title;
        } else {
            message = [NSString stringWithFormat:@"%@：%@",userInfo[@"title"],userInfo[@"body"]];
        }
        
        WEAK_SELF(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            STRONG_SELF(self);
            NSArray *array = [[userInfo objectForKey:@"identifier"] componentsSeparatedByString:@"_"];
            [self pushProgramVC:[array[1] integerValue]];
            
        }];
        
        // Add the actions.
        [alertController addAction:otherAction];
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)bat_getLocalNotification:(NSDictionary *)launchOptions
{
    // 本地通知内容获取：
    UILocalNotification *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification != nil) {
        
        DDLogDebug(@"测试1");
        
        NSDictionary *userInfo = localNotification.userInfo;
        NSArray *array = [[userInfo objectForKey:@"identifier"] componentsSeparatedByString:@"_"];
        [self pushProgramVC:[array[1] integerValue]];
    }
}

- (void)pushProgramVC:(NSInteger)templateID
{
    BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];

    programDetailVC.templateID = templateID;
    programDetailVC.isFromTest = NO;
    programDetailVC.hidesBottomBarWhenPushed = YES;
    [[Tools getCurrentVC].navigationController pushViewController:programDetailVC animated:YES];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([BATClockManager shared].isPopHealthThreeSecondVC == YES) {
            [[Tools getCurrentVC].navigationController popToViewController:[BATClockManager shared].healthThreeSecondVC animated:YES];
        } else {
            BATHealthThreeSecondsController *healthThreeSecondsVC = [[BATHealthThreeSecondsController alloc]init];
            healthThreeSecondsVC.hidesBottomBarWhenPushed = YES;
            [[Tools getCurrentVC].navigationController pushViewController:healthThreeSecondsVC animated:YES];
        }
    }
}
#pragma mark - HealthThreedSecond

- (void)setHealthThreeSecondLocalNotificationInfo {
    NSDate *saveDate = [[NSUserDefaults standardUserDefaults] objectForKey:BATHealthThreeSecondDateKey];
    if (saveDate != nil) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval st = [saveDate timeIntervalSince1970];
        NSTimeInterval t = [date timeIntervalSince1970]+10;
        if (t-st>0.0) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BATHealthThreeSecondDateKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[BATClockManager shared] registerHealthThreeSecondLocalNotificationWithTitle:nil body:@"要坚持记录，为你的健康打卡！" date:saveDate];
        }
    }
}
//打卡本地通知
//- (void)setUserLocalNotificationSettings:(UIApplication *)application {
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
//        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                DDLogDebug(@"注册ios10本地通知成功");
//                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//                    DDLogDebug(@"");
//                }];
//            } else {
//                DDLogDebug(@"注册iOS10本地通知失败");
//            }
//        }];
//    }
//}
//#pragma mark - UNUserNotificationCenterDelegate
//前台收到通知
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"app在--前台前台前台前台--收到了通知" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [ALERT show];
//    completionHandler(UNNotificationPresentationOptionAlert);
//}

//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"app在--后台后台后台后台--收到了通知" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [ALERT show];
//}
@end
