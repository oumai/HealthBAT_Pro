//
//  HTTPTool+BATKmWlyyRequest.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATKmWlyyRequest)

/**
 网络医院 基础api

 @param URLString url
 @param parameters 参数
 @param type 请求类型
 @param success 成功
 @param failure 失败
 */
+ (void)requestWithKmWlyyBaseApiURLString:(NSString *)URLString
                               parameters:(id)parameters
                                     type:(XMHTTPMethodType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError * error))failure;

//
///**
// 网络医院 通用api
//
// @param URLString url
// @param parameters 参数
// @param type 请求类型
// @param success 成功
// @param failure 失败
// */
//+ (void)requestWithKmWlyyCommonApiURLString:(NSString *)URLString
//                                 parameters:(id)parameters
//                                       type:(XMHTTPMethodType)type
//                                    success:(void (^)(id responseObject))success
//                                    failure:(void (^)(NSError * error))failure;
//
///**
// 网络医院 药店api
//
// @param URLString url
// @param parameters 参数
// @param type 请求类型
// @param success 成功
// @param failure 失败
// */
//+ (void)requestWithKmWlyyYdApiURLString:(NSString *)URLString
//                             parameters:(id)parameters
//                                   type:(XMHTTPMethodType)type
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError * error))failure;
//
///**
// 网络医院 用户api
//
// @param URLString url
// @param parameters 参数
// @param type 请求类型
// @param success 成功
// @param failure 失败
// */
//+ (void)requestWithKmWlyyUserApiURLString:(NSString *)URLString
//                               parameters:(id)parameters
//                                     type:(XMHTTPMethodType)type
//                                  success:(void (^)(id responseObject))success
//                                  failure:(void (^)(NSError * error))failure;


/**
 网络医院，用来获取图片

 @param URLString 图片地址，recipeFilesUrl+/7
 @param success 成功
 @param failure 失败
 */
+ (void)requestWithKmWlyyImageApiURLString:(NSString *)URLString
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError * error))failure;

@end
