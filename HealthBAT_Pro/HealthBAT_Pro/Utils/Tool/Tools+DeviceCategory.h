//
//  Tools+DeviceCategory.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/102017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "Tools.h"

@interface Tools (DeviceCategory)

/*
 获取设备描述
 */
+ (NSString *)getCurrentDeviceModelDescription;
/*
 由获取到的设备描述，来匹配设备型号
 */
+ (NSString *)getCurrentDeviceModel;


/**
 保存设备信息到本地
 */
+ (void)saveDeviceInfo;
@end
