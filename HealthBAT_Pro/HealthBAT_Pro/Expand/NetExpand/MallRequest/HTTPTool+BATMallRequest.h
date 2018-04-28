//
//  HTTPTool+BATMallRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/10/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATMallRequest)
/**
 电商请求

 @param URLString  url
 @param parameters 参数
 @param success    成功
 @param failure    失败
 */
+ (void)requestWithMallURLString:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError * error))failure;

@end
