//
//  BATAppDelegate+BATResetLogin.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATResetLogin.h"
#import "BATPerson.h"
#import "SVProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "BATTIMDataModel.h"
#import "BATClockManager.h"
#import "BATVisitConfigModel.h"
#import "BATAgoraSignalingManager.h"
#import "BATAppDelegate+BATTabbar.h"//红点
#import "BATAppDelegate+BATPromoCode.h"//获奖
#import "BATMemberInfoModel.h"

#import "KeychainItemWrapper.h"

@implementation BATAppDelegate (BATResetLogin)

- (void)bat_LoginWithUserName:(NSString *)userName password:(NSString *)password Success:(void(^)(void))success failure:(void(^)(NSError * error))failure {

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/Login"
                        parameters:@{
                                     @"AccountName":userName,
                                     @"PhoneNumber":@"",
                                     @"PassWord":password,
                                     @"LoginType":@"1"
                                     }
                              type:kPOST
                           success:^(id responseObject) {

                               BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];

                               if (login.ResultCode == 0) {
                                  
                                   [self successActionWithLogin:login userName:userName password:password];

                                   if (success) {
                                       success();
                                   }
                               }
                           }
                           failure:^(NSError *error) {

                               if (failure) {
                                   failure(error);
                               }
                           }];
}

- (void)bat_autoLoginWithTokenSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    
    [HTTPTool requestWithURLString:@"/api/networkmedical/logintoken" parameters:@{@"token":LOCAL_TOKEN} type:kGET success:^(id responseObject) {
        
        BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];

        if (login.ResultCode == 0) {
            
            [self autoLoginSuccessActionWithLogin:login];
            
            if (success) {
                success();
            }
        }
    } failure:^(NSError *error) {
        
        [self bat_logout];
        if (failure) {
            failure();
        }
    }];
}

- (void)autoLoginSuccessActionWithLogin:(BATLoginModel *)login {
    
    //改变登录状态
    SET_LOGIN_STATION(YES);
    
    //获取个人信息
    [self personInfoListRequest];
    
    //获取会员信息
    [self requestGetUserCard];
    
    //获取云通讯配置信息
    [self getTIMDataRequest];
    
    //登录融云
    [self rongCloudLoginWithToken:login.Data.RongCloudToken];
    
    //登录声网信令
    [self agoraSignalingLoginWithAccount:[NSString stringWithFormat:@"%ld",(long)login.Data.ID] token:login.Data.AgoraToken];
    
    //设置极光推送别名
    [[BATJPushManager sharedJPushManager] setAlias:[NSString stringWithFormat:@"BAT%ld",(long)login.Data.ID]];
    
    //设置闹钟
    [[BATClockManager shared] resetClock];
    
    //获取商城、咨询、挂号是否打开的状态信息
    [self getVisitStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BAT_LOGIN_SUCCESS" object:nil];
}

- (void)bat_autoLoginSuccess:(void(^)(void))success failure:(void(^)(void))failure {

    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    NSError *error;
    NSString * password = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:ServiceName error:&error];
    if(error){
        DDLogError(@"从Keychain里获取密码出错：%@",error);
        return;
    }

    if (!password || !userName) {
        //密码或者用户名未获取到，退出登录
        [self bat_logout];
        return;
    }
    
    [self bat_LoginWithUserName:userName password:password Success:^{

        if (success) {
            success();
        }
    } failure:^(NSError *error) {

        [self bat_logout];
        if (failure) {
            failure();
        }
    }];
}

- (void)successActionWithLogin:(BATLoginModel *)login userName:(NSString *)userName password:(NSString *)password {
    
    //登录成功
    if (login.Data.AccountType == 2) {
        //医生账号，暂时不能登陆
        [SVProgressHUD showErrorWithStatus:@"账号异常"];
        return ;
    }
    
    //是否领取获奖
    if(login.Data.IsDiscount == 1){
        BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate bat_showPrompt];
    }

    
    //保存密码
    if (userName && password) {
        NSError  *error;
        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"LOGIN_NAME"];
        BOOL saved = [SFHFKeychainUtils storeUsername:userName andPassword:password forServiceName:ServiceName updateExisting:YES error:&error];
        if(!saved){
            DDLogError(@"保存密码时出错：%@",error.localizedDescription);
        }
    }
    
    //保存登录信息
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
    [NSKeyedArchiver archiveRootObject:login toFile:file];
    [[NSUserDefaults standardUserDefaults] setValue:login.Data.Token forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
#ifdef TESTING
    
    //保存sessionID
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKMHealthCloudKey accessGroup:nil];
    [wrapper setObject:@"HealthBAT_Pro" forKey:(id)kSecAttrService];
    [wrapper setObject:login.Data.SessionId forKey:(id)kSecValueData];
    [wrapper setObject:login.Data.Mobile forKey:(id)kSecAttrAccount];
    
#endif
    
    //改变登录状态
    SET_LOGIN_STATION(YES);
    
    //获取个人信息
    [self personInfoListRequest];
    
    //获取会员信息
    [self requestGetUserCard];
    
    //获取云通讯配置信息
    [self getTIMDataRequest];
    
    //登录融云
    [self rongCloudLoginWithToken:login.Data.RongCloudToken];
    
    //登录声网信令
    [self agoraSignalingLoginWithAccount:[NSString stringWithFormat:@"%ld",(long)login.Data.ID] token:login.Data.AgoraToken];
    
    //设置极光推送别名
    [[BATJPushManager sharedJPushManager] setAlias:[NSString stringWithFormat:@"BAT%ld",(long)login.Data.ID]];
    
    //设置闹钟
    [[BATClockManager shared] resetClock];
    
    //获取商城、咨询、挂号是否打开的状态信息
    [self getVisitStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BAT_LOGIN_SUCCESS" object:nil];
}

//登录云通信
- (void)getTIMDataRequest{
    
    [HTTPTool requestWithURLString:@"/api/Account/GetIMConfig" parameters:nil type:kGET success:^(id responseObject) {
        
        BATTIMDataModel *TIMData= [BATTIMDataModel mj_objectWithKeyValues:responseObject];
        
        if (TIMData.ResultCode == 0) {
            
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"];
            [NSKeyedArchiver archiveRootObject:TIMData toFile:file];
            
            [[BATTIMManager sharedBATTIM] bat_loginTIM];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//登录融云
- (void)rongCloudLoginWithToken:(NSString *)rongCloudToken {
    
    [[BATRongCloudManager sharedBATRongCloudManager] bat_loginRongCloudWithToken:rongCloudToken success:^(NSString *userId) {
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
}

//登录信令
- (void)agoraSignalingLoginWithAccount:(NSString *)account token:(NSString *)token {
    
    [[BATAgoraSignalingManager shared] login:account token:token deviceID:nil complete:^(BOOL success) {
        
    }];
}

//获取个人信息
- (void)personInfoListRequest {

    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {

        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {

            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
            [[NSNotificationCenter defaultCenter] postNotificationName:BATLoginSuccessGetUserInfoSucessNotification object:person];
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
//是否为付费用户
- (void)requestIsVIPUser
{
    [HTTPTool requestWithURLString:@"/api/Account/IsVipUser" parameters:nil type:kPOST success:^(id responseObject) {
        
        //保存VIP状态
        BOOL isVIP = [[[responseObject objectForKey:@"Data"] objectForKey:@"IsVip"] boolValue];
        SET_VIP(isVIP);
        
    } failure:^(NSError *error) {
        
    }];
}
 */

//获取会员信息
- (void)requestGetUserCard
{
    [HTTPTool requestWithURLString:@"/api/Account/GetUserCard" parameters:nil type:kGET success:^(id responseObject) {
        
        
        BATMemberInfoModel *memberInfoModel = [BATMemberInfoModel mj_objectWithKeyValues:responseObject];
        
        //保存会员信息
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MemberInfo.data"];
        [NSKeyedArchiver archiveRootObject:memberInfoModel toFile:file];

    } failure:^(NSError *error) {
    }];
}

//获取商城、咨询、挂号是否打开的状态信息
- (void)getVisitStatus {
    
    [HTTPTool requestWithURLString:@"/api/Common/GetVisitConfig" parameters:nil type:kGET success:^(id responseObject) {
        BATVisitConfigModel *visitConfigModel = [BATVisitConfigModel mj_objectWithKeyValues:responseObject];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanConsult forKey:@"CanConsult"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanRegister forKey:@"CanRegister"];
        [[NSUserDefaults standardUserDefaults] setBool:visitConfigModel.CanVisitShop forKey:@"CanVisitShop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(NSError *error) {
        
    }];
}



//退出登录
- (void)bat_logout {

    //点击了退出登录按钮
    [NBSAppAgent trackEvent:LIGIN_OUT_BUTTON_CLICK withEventTag:@"点击了退出登录按钮" withEventProperties:nil];
    
    
    
    DDLogDebug(@"退出登录");
    SET_LOGIN_STATION(NO);
//    SET_VIP(NO);
    
    //清楚token
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Out_Hidden_Consultion_Order_Data" object:nil];

    //发送推出登陆的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLICATION_LOGOUT" object:nil];

    //退出云通信
    [[BATTIMManager sharedBATTIM] bat_loginOutTIM];
    
    //退出融云
    [[BATRongCloudManager sharedBATRongCloudManager] bat_loginOutRongCloud];
    
    //退出声网信令
    [[BATAgoraSignalingManager shared] logout:^(BOOL success) {
        
    }];
    
    //极光清除别名
    [[BATJPushManager sharedJPushManager] setAlias:@""];
    
    //设置闹钟
    [[BATClockManager shared] removeClock:nil];

    //清除本地数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MemberInfo.data"] error:nil];

    //清除缓存
    [self cleanCacheAndCookie];

    //重新获取三个开关的状态
    [self getVisitStatus];
    
    //清楚推送
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //清除咨询红点
//    [self setTarBarWithMessageCount:0];

    //界面跳转
    BATRootTabBarController *rootTabBar = (BATRootTabBarController *)self.window.rootViewController;
    for (UINavigationController * nav in rootTabBar.viewControllers) {

        [nav popToRootViewControllerAnimated:YES];
    }
    [self bk_performBlock:^(id obj) {
        
        SET_LOGIN_STATION(NO);
        
        //没登录状态，点击 tabBar “关注”不需要显示指示器
        if (rootTabBar.selectedIndex == 1) { return; }
        [SVProgressHUD showSuccessWithStatus:@"退出登录"];
    } afterDelay:0.5];

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]];
//    [rootTabBar presentViewController:nav animated:YES completion:nil];
//    [self performSelector:@selector(backHome) withObject:nil afterDelay:1];
}

- (void)backHome {
    BATRootTabBarController *rootTabBar = (BATRootTabBarController *)self.window.rootViewController;
    [rootTabBar setSelectedIndex:0];
}

- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


@end
