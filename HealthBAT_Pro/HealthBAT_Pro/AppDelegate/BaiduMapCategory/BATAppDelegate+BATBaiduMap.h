//
//  BATAppDelegate+BATBaiduMap.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate.h"
#import "BATAppDelegate_BATBaiduMap.h"

@interface BATAppDelegate (BATBaiduMap)<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

/**
 *  启动百度地图
 */
- (void)bat_startBaiduMap;

/**
 *  获取当前地理位置
 */
- (void)bat_getLocation;

@end
