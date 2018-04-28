//
//  BATWeChatPayHandle.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h" //微信支付

@interface BATWeChatPayHandle : NSObject <WXApiDelegate>

+ (BATWeChatPayHandle *)shareWeChatPayHandle;

@end
