//
//  BATKMPayHandle.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATKMPayHandle.h"
#import "BATPayManager.h"
#import "SVProgressHUD.h"

@implementation BATKMPayHandle

+ (BATKMPayHandle *)shareKMPayHandle
{
    static BATKMPayHandle *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATKMPayHandle alloc] init];
        
        //康美支付 没安装app
        if (![KMTPayApi isKMTPayInstalled]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPayResult:) name:@"orderPayResult" object:nil];
        }
    });
    return instance;
}

#pragma mark - 处理康美支付结果
#pragma mark - KMTPayApiDelegate
- (void)onResp:(KMTPayResp *)resp
{
    KMTPayResp *response = (KMTPayResp *)resp;
    switch (response.errorCode) {
            
        case KMTPaySuccess:
            DDLogInfo(@"康美支付成功");
            [[BATPayManager shareManager] payCompleteVerification:YES];
            break;
        case KMTPayErrCodeUserCancel:
            DDLogInfo(@"康美支付取消");
            break;
        default:
            DDLogInfo(@"康美支付失败");
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            break;
    }
}

+ (void)orderPayResult:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    //获取支付结果
    NSDictionary *result   = [userInfo valueForKey:@"result"];
    
    KMTPayResp *response = [KMTPayResp mj_objectWithKeyValues:result];
    
    switch (response.errorCode) {
            
        case KMTPaySuccess:
            DDLogInfo(@"康美支付成功");
            [[BATPayManager shareManager] payCompleteVerification:YES];
            break;
        case KMTPayErrCodeUserCancel:
            DDLogInfo(@"康美支付取消");
            break;
        default:
            DDLogInfo(@"康美支付失败");
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            break;
    }
    
}


@end
