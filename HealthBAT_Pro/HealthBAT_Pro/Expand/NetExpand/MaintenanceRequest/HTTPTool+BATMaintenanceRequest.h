//
//  HTTPTool+BATMaintenanceRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATMaintenanceRequest)

/**
 培训师请求
 
 @param URLString  url
 @param parameters 参数
 @param success    成功
 @param failure    失败
 */
+ (void)requestWithMaintenanceURLString:(NSString *)URLString
                             parameters:(id)parameters
                                   type:(XMHTTPMethodType)type
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError * error))failure;

@end
