//
//  BATAppDelegate+BATInitXunfeiSDK.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/182017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATInitXunfeiSDK.h"
#import "iflyMSC/IFlyMSC.h"

@implementation BATAppDelegate (BATInitXunfeiSDK)

- (void)bat_initXunfeiSDK {
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    DDLogDebug(@"讯飞语音识别--version: %@ " ,[IFlySetting getVersion]);
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"587701e1"];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

}
@end
