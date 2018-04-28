//
//  HTTPTool+BATNetworkMedicalUploadImage.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATNetworkMedicalUploadImage)

/**
 *  上传文件
 *
 *  @param dataArray      图片数组
 *  @param success        成功回调block
 *  @param failure        失败回调block
 */
+ (void)requestUploadImageToKMWithParams:(NSArray *)dataArray
                                 success:(void(^)(NSArray *severImageArray))success
                                 failure:(void(^)(NSError *error))failure
                       fractionCompleted:(void(^)(double count))fractionCompleted;


@end
