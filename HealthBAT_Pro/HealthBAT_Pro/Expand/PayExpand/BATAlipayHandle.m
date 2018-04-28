//
//  BATAlipayHandle.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAlipayHandle.h"
#import "BATPayManager.h"
#import "SVProgressHUD.h"

@implementation BATAlipayHandle

+ (BATAlipayHandle *)shareAlipayHandle
{
    static BATAlipayHandle *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATAlipayHandle alloc] init];
    });
    return instance;
}

#pragma mark - 处理支付宝支付结果
- (void)handleAliPay:(NSURL *)url
{
    WEAK_SELF(self);
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        STRONG_SELF(self);
        [self handleResult:resultDic];
    }];
}

- (void)handleResult:(NSDictionary *)result
{
    if ([[result objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        //支付成功
        [[BATPayManager shareManager] payCompleteVerification:YES];
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"4000"]) {
        //支付失败
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudio_PayState_Cancel" object:nil];
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"8000"]) {
        //正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        //用户中途取消
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudio_PayState_Cancel" object:nil];
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"6002"]) {
        //网络连接出错
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudio_PayState_Cancel" object:nil];
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"6004"]) {
        //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    } else if ([[result objectForKey:@"resultStatus"] isEqualToString:@"5000"]) {
        //重复请求
    }
    
}

@end
