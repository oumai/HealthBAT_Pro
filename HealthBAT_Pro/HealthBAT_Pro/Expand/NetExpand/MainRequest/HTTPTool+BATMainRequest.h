//
//  HTTPTool+BATMainRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATMainRequest)


/**
 *  .net接口 封装
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       请求类型
 *  @param success    请求成功
 *  @param failure    请求失败
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(XMHTTPMethodType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;



@end
