//
//  HTTPTool+BATUploadImage.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"
#import "BATUploadImageModel.h"

@interface HTTPTool (BATUploadImage)

/**
 *  上传文件
 *
 *  @param params         数据体
 *  @param data           上传的文件data
 *  @param fileSuffixName 上传的文件后缀名
 *  @param success        成功回调block
 *  @param failure        失败回调block
 */
+ (void)requestUploadImageToBATWithParams:(id)params
                constructingBodyWithBlock:(void (^)(XMRequest *request))block
                                  success:(void(^)(NSArray *imageArray))success
                                  failure:(void(^)(NSError *error))failure
                        fractionCompleted:(void(^)(double count))fractionCompleted;

@end
