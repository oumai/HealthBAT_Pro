//
//  BATAppDelegate+BATRongCloud.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATRongCloud.h"
#import <RongIMLib/RongIMLib.h>//融云
#import "BATNotificationMessage.h"

@implementation BATAppDelegate (BATRongCloud)

- (void)bat_initRongCloud {
    
#ifdef ENTERPRISERELEASE
    [[RCIM sharedRCIM] initWithAppKey:@"e0x9wycfeh4xq"];
#elif RELEASE
    [[RCIM sharedRCIM] initWithAppKey:@"e0x9wycfeh4xq"];
#elif PRERELEASE
    [[RCIM sharedRCIM] initWithAppKey:@"e0x9wycfeh4xq"];
#else
    [[RCIM sharedRCIM] initWithAppKey:@"82hegw5u83yhx"];
#endif
    
    [[RCIM sharedRCIM] registerMessageType:[BATNotificationMessage class]];
    
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    
    [RCIM sharedRCIM].globalNavigationBarTintColor = UIColorFromHEX(0x333333, 1);
    
    [BATRongCloudManager sharedBATRongCloudManager];
}
@end
