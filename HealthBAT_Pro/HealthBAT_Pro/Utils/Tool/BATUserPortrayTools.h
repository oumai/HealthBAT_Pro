//
//  BATUserPortrayTools.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATUserPortrayTools : NSObject
/**
 *  测试搜索域名是否可用
 *
 *  @return 搜索域名是否可用
 */
+ (BOOL)isExistenceSearchNetwork;

//用户模块操作
+ (void)saveOperateModuleRequestWithURL:(NSString *)URLString pathName:(NSString *)pathName moduleId:(NSInteger)moduleId beginTime:(NSString *)beginTime;
//用户游览操作
+ (void)saveUserBrowseRequestWithURL:(NSString *)URLString moduleName:(NSString *)moduleName moduleId:(NSString *)moduleId beginTime:(NSString *)beginTime browsePage:(NSString *)browsePage;
@end
