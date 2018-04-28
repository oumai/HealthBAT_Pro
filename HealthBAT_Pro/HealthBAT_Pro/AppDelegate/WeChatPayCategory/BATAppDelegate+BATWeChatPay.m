//
//  BATAppDelegate+BATWeChatPay.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATWeChatPay.h"
#import "WXApi.h"

@implementation BATAppDelegate (BATWeChatPay)

- (void)bat_registerWeChatPay
{
    [WXApi registerApp:WeChatAppId];
//    [WXApi registerApp:WeChatAppId withDescription:@"BAT"];
}

@end
