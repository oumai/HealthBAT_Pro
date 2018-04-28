//
//  BATAppDelegate+AgoraCategory.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"

#import "BATAgoraManager.h"
#import "BATAgoraSignalingManager.h"

@interface BATAppDelegate (AgoraCategory)<BATAgoraSignalingManagerDelegate>

/**
 初始化声网
 */
- (void)bat_registerAgora;

@end
