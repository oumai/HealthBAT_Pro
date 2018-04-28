//
//  BATPhotoPickHelper.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATPhotoPickHelper : NSObject

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)checkPhotoLibraryAuthorizationStatus:(void(^)(BOOL havePower))resultBlock;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

@end
