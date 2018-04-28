//
//  BATAppDelegate+BATTingYunCategory.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2018/1/18.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATTingYunCategory.h"

@implementation BATAppDelegate (BATTingYunCategory)
- (void)bat_registerTingYun{
    
    //设置面包屑,面包屑能够更好的协助用户调查崩溃发生的原因，可以知晓用户发生崩溃之前的代码逻辑与崩溃轨迹结合使用能够更好的复现用户崩溃场景。
    // ---->start!
    //重定向host
    
    [NBSAppAgent setRedirectURL:@"ty-app.kmhealthcloud.com:8081"];
    [NBSAppAgent setHttpEnabled:YES];
    
}
@end
