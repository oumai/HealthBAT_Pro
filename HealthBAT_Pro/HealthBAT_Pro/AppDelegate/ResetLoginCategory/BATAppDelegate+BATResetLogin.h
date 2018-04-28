//
//  BATAppDelegate+BATResetLogin.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"
#import "BATLoginViewController.h"
#import "BATLoginModel.h"

@interface BATAppDelegate (BATResetLogin)


/**
 bat登陆

 @param userName 用户名
 @param password 用户密码
 @param success 成功
 @param failure 失败
 */
- (void)bat_LoginWithUserName:(NSString *)userName password:(NSString *)password Success:(void(^)(void))success failure:(void(^)(NSError * error))failure;

/**
 登录成功
 
 @param login 登录model
 @param userName 用户名
 @param password 密码
 */
- (void)successActionWithLogin:(BATLoginModel *)login userName:(NSString *)userName password:(NSString *)password;

/**
 *  app自动登陆
 */
- (void)bat_autoLoginSuccess:(void(^)(void))success failure:(void(^)(void))failure;


/**
 app用token自动登录

 @param success 成功
 @param failure 失败
 */
- (void)bat_autoLoginWithTokenSuccess:(void(^)(void))success failure:(void(^)(void))failure;

/**
 获取三个开关
 */
- (void)getVisitStatus;

/**
 *  重置登录状态，登录判断－2状态，需要重新登录
 */
- (void)bat_logout;

@end
