//
//  HTTPTool+BATUploadImage.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATUploadImage.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATUploadImage)

+ (void)requestUploadImageToBATWithParams:(id)params
                constructingBodyWithBlock:(void (^)(XMRequest *request))block
                                  success:(void(^)(NSArray *imageArray))success
                                  failure:(void(^)(NSError *error))failure
                        fractionCompleted:(void(^)(double count))fractionCompleted
{
    
    [XMCenter sendRequest:^(XMRequest *request) {
        
        request.url = @"http://upload.jkbat.com";
        request.requestType = kXMRequestUpload;
        if (block) {
            block(request);
        }
        
    } onProgress:^(NSProgress *progress) {
        
        if (fractionCompleted) {
            fractionCompleted(progress.fractionCompleted);
        }
    } onSuccess:^(id responseObject) {
        
        NSArray *imageArray = (NSArray *)responseObject;
        if (success) {
            success(imageArray);
        }
    } onFailure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
    
}

@end
