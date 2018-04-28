//
//  BATAlipayHandle.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h> //支付宝支付

@interface BATAlipayHandle : NSObject

+ (BATAlipayHandle *)shareAlipayHandle;

- (void)handleAliPay:(NSURL *)url;

- (void)handleResult:(NSDictionary *)result;

@end
