//
//  BATWeChatPayHandle.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWeChatPayHandle.h"
#import "BATPayManager.h"
#import "SVProgressHUD.h"

@implementation BATWeChatPayHandle

+ (BATWeChatPayHandle *)shareWeChatPayHandle
{
    static BATWeChatPayHandle *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATWeChatPayHandle alloc] init];
    });
    return instance;
}

#pragma mark - 处理微信支付结果
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DDLogInfo(@"支付成功");
                [[BATPayManager shareManager] payCompleteVerification:YES];
                break;
            default:
                DDLogInfo(@"支付失败，retcode=%d",resp.errCode);
                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BATDoctorStudio_PayState_Cancel" object:nil];
                break;
        }
    }
}

@end
