//
//  AppDelegate.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"
//appDelegate类别
#import "BATAppDelegate+BATXcodeSetting.h"//视图控制器设置
#import "BATAppDelegate+BATViewControllerSetting.h"//xcodeColors设置
#import "BATAppDelegate+BATBaiduMap.h"//百度地图
#import "BATAppDelegate+BATShareCategory.h"//分享
#import "BATAppDelegate+BATInitXunfeiSDK.h"//初始化讯飞
#import "BATAppDelegate+BATFeedBack.h"//意见反馈（暂时不用，可以用来测试）
#import "BATAppDelegate+BATVersion.h"//版本
#import "BATAppDelegate+BATWeChatPay.h" //注册微信
#import "BATAppDelegate+BATJPushCategory.h"     //极光
#import "BATAppDelegate+BATResetLogin.h"//登录
#import "BATAppDelegate+BATRongCloud.h"//融云
#import "BATAppDelegate+AgoraCategory.h"//声网
#import "BATAppDelegate+BATTabbar.h"//红点
#import "BATAppDelegate+BATTableViewCategory.h"

#import "BATAppDelegate+BATPromoCode.h" //获奖提示


#import "IQKeyboardManager.h"//键盘管理
#import "SVProgressHUD.h"//提示框

#import "HTTPTool+BATDomainAPI.h"//获取域名
#import "BATPayManager.h"//支付

#import "Tools+DeviceCategory.h"//设备信息

//#import "BATGuideView.h"

#import "BATPushModel.h"

#import "BATRoundGuideViewController.h"

#import "BATIAPManager.h"

#import "BATHealth360EvaluationViewController.h"

@interface BATAppDelegate ()

@property (nonatomic,assign) BOOL isNeedPushEvaluationVC;

@end

@implementation BATAppDelegate

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
#ifdef DEBUG
    NSLog(@"DEBUG");
#elif TESTING
    NSLog(@"TESTING");
#elif PUBLICRELEASE
    NSLog(@"PUBLICRELEASE");
#elif PRERELEASE
    NSLog(@"PRERELEASE");
#elif ENTERPRISERELEASE
    NSLog(@"ENTERPRISERELEASE");
#elif RELEASE
    NSLog(@"RELEASE");
#endif
    

#ifdef RELEASE
//正式环境
//    [HTTPTool domainRequest];
#endif
    //支付宝 appId ： 2016092101939879 健康BATV3.13_beta_2018011601_Azure预发布环境
    
    //获取最新的域名
    [HTTPTool getDomain];
    
    //设备
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"ImageResolutionHeight"]) {
        [Tools saveDeviceInfo];
    }
    
    //第三方ui控件设置
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0, 0, 0, 0.3)];//设置HUD的背景颜色

    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[BATHomeThemeManager shareInstance] homeThemeInitConfig];//加载主题初始化配置
    
    //创建window
    self.rootTabBarController = [[BATRootTabBarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.rootTabBarController;
    
    self.navHomeVC = [[UINavigationController alloc] initWithRootViewController:[[BATNavHomeViewController alloc] init]];
    [self.rootTabBarController presentViewController:self.navHomeVC animated:NO completion:nil];

    //初始化默认信息（三个开关）
    if (LOGIN_STATION) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CanConsult"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CanConsult"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CanRegister"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CanVisitShop"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //初始化听云
    [self bat_registerTingYun];
    
    //设置XcodeColors
    [self bat_setXcodeColorsConfigration];
    
    //设置VC
    [self bat_settingVC];
    [self bat_VCDissmiss];
    //设置iOS11 tableView 适配
    [self cancelTableViewAdjust];
    
    //初始化融云
    [self bat_initRongCloud];
    
    //初始化声网
    [self bat_registerAgora];
    
    //初始化shareSDK
    [self bat_shareInit];

    //启动百度地图
    [self bat_startBaiduMap];
    [self bat_getLocation];
    
    //初始化JPush
    [self bat_registerAPNS];
    [self bat_registerJPush:launchOptions];
    [self setHealthThreeSecondLocalNotificationInfo];
    
    if (launchOptions && [launchOptions.allKeys containsObject:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
        if ([launchOptions.allKeys containsObject:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            
            BATPushModel *model = [BATPushModel mj_objectWithKeyValues:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
            
            
            if (model.JPushMsgType == BATJPushMsgTypeNoraml) {
                
                
                
            }
            else {
                
                // do something else
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_PUSH_MESSAGE_VC" object:nil];
                });
            }
        }
        

    }
    if (!IS_IOS10) {
        [self bat_getLocalNotification:launchOptions];
    }

    //初始化讯飞
    [self bat_initXunfeiSDK];
    
    //重新登陆
    if (LOGIN_STATION) {
        [self bat_autoLoginWithTokenSuccess:^{
            
        } failure:^{
            
        }];
    
    }
    
//    //设置角标0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    //设置健康咨询红点
//    NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
//    [self setTarBarWithMessageCount:oldArr.count];
    
    //意见反馈
//    [self bat_feedBack];

    //注册微信支付
    [self bat_registerWeChatPay];
    
    //设置iap监听
    [[BATIAPManager shareManager] addTransactionObserver];
    
    //检查未验证的票据
    [[BATIAPManager shareManager] checkUnchekReceipt];
        
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //清除本地历史数据（挂号部分的地理位置信息）
    [Tools removeLocalDataWithFile:location160Data];
    [Tools removeLocalDataWithFile:locationDepartmentData];


    //获取地理位置信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bat_getLocation) name:@"BEGIN_GET_LOCATION" object:nil];

    //接口返回－2，登录失败，重置登录状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bat_logout) name:@"LOGIN_FAILURE" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushHealth360EvaluationVC) name:@"BAT_LOGIN_SUCCESS" object:nil];
/*
   //引导页
   NSString *currentID =  [Tools getLocalVersion];
   NSString *localID = [[NSUserDefaults standardUserDefaults] valueForKey:@"version"];
   if (![currentID isEqualToString:localID]) {
        [[NSUserDefaults standardUserDefaults] setValue:currentID forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        BATGuideView  *guideView = [[BATGuideView alloc]initWithFrame:self.window.bounds];
        [self.window addSubview:guideView];
       [self.window bringSubviewToFront:guideView];
    }
*/
    //监控网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    Reachability *reach = [Reachability reachabilityWithHostName:@"www.jkbat.com"];
    [reach startNotifier];

#ifdef ENTERPRISERELEASE
    //企业版更新
    [self bat_versionEnterprise];
#elif RELEASE
    //AppStore更新
    [Tools updateVersion];
#endif

    return YES;
}

- (void)reachabilityChanged:(NSNotification *)noti {

    BOOL isNetwork = YES;
    
    Reachability *reachability = [noti object];
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:
            DDLogDebug(@"无网络");
            isNetwork = NO;
            [[NSUserDefaults standardUserDefaults] setBool:isNetwork forKey:@"netStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_NOT_NET_STATION" object:nil];
            
            break;
        case ReachableViaWiFi:
            DDLogDebug(@"wifi网络");
            isNetwork = YES;
            [[NSUserDefaults standardUserDefaults] setBool:isNetwork forKey:@"netStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case ReachableViaWWAN:
            DDLogDebug(@"移动网络");
            isNetwork = YES;
            [[NSUserDefaults standardUserDefaults] setBool:isNetwork forKey:@"netStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshOnlineLearningInterfaceNotification object:@(isNetwork)];
}

#pragma mark - Application
- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //讲融云用户信息写入本地
    [[BATRongCloudManager sharedBATRongCloudManager] bat_rongCloudUserWriteToFile];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyBordClose" object:nil];
    //后台运行
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //首页消息角标变化
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE" object:nil];
        
    
    [self bat_getLocation];
    
    [self getVisitStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"=========");
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[BATIAPManager shareManager] removeTransactionObserver];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RANDNUMBERS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //离开引擎频道
    [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
        
    }];
    
    //讲融云用户信息写入本地
    [[BATRongCloudManager sharedBATRongCloudManager] bat_rongCloudUserWriteToFile];
}

#pragma mark - 系统回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [BATPayManager handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    //小管家唤起bat
    if ([url.absoluteString containsString:@"com.KmHealthBAT.app://"]) {
        
        if ([url.absoluteString containsString:@"healthEvaluateReport"]) {
            
            [self bk_performBlock:^(id obj) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HEALTH_MANAGER_PUSH_360EVALUATION_VC" object:nil userInfo:@{@"FromBATManager":@"YES"}];
                
                [self pushHealth360EvaluationVC];
                
                self.isNeedPushEvaluationVC = YES;
            } afterDelay:2];
        }
        
        return YES;
    }
    
    if ([url.absoluteString containsString:@"platformId"]) {
        return [OpenShare handleOpenURL:url];
    }
    
    return [BATPayManager handleOpenURL:url];
}

- (void)pushHealth360EvaluationVC {
    
    BATHealth360EvaluationViewController *evaluationVC = [[BATHealth360EvaluationViewController alloc] init];
    evaluationVC.urlSuffix = @"&redirect=/H5/src/index.html?src=2#/healthEvaluateReport/////2";
    [self.rootTabBarController presentViewController:[[UINavigationController alloc] initWithRootViewController:evaluationVC] animated:YES completion:nil];
    
//    if (!LOGIN_STATION) {
//
//        [self.rootTabBarController presentViewController:[[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]] animated:YES completion:nil];
//        return;
//    }
//
//    if (self.isNeedPushEvaluationVC != YES) {
//        return;
//    }
//    self.isNeedPushEvaluationVC = NO;
//
//    [self bk_performBlock:^(id obj) {
//
//
//    } afterDelay:1.0];

}


@end
