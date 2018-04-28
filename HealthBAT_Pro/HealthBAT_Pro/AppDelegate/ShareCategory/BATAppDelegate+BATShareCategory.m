//
//  BATAppDelegate+BATShareCategory.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/11/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATShareCategory.h"

@implementation BATAppDelegate (BATShareCategory)

- (void)bat_shareInit {
    
    //全局注册appId，别忘了
    [OpenShare connectQQWithAppId:@"1105372508"];
    [OpenShare connectWeiboWithAppKey:@"2990270720"];
    [OpenShare connectWeixinWithAppId:WeChatAppId];
}

@end
