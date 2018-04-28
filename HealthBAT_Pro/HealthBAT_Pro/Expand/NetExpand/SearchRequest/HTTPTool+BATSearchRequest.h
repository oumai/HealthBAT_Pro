//
//  HTTPTool+BATSearchRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/302016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATSearchRequest)


/**
 java基础请求

 @param URLString url
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)requestWithBaseJavaURLString:(NSString *)URLString
                          parameters:(id)parameters
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError * error))failure;
/**
 *  搜索接口
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param success    成功
 *  @param failur     失败
 */
+ (void)requestWithSearchURLString:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failur;


/**
 康博士接口

 @param URLString url
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)requestWithDrKangURLString:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failure;
@end
