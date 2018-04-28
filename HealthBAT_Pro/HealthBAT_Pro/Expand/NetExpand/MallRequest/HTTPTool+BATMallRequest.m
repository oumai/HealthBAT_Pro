
//
//  HTTPTool+BATMallRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/10/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATMallRequest.h"
#import "BATSearchBaseModel.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATMallRequest)

+ (void)requestWithMallURLString:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError * error))failure {


    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = MALL_URL;
        request.api = URLString;
        request.parameters = parameters;
        if (LOGIN_STATION) {
            request.headers = @{@"Token":LOCAL_TOKEN};
        }
        request.httpMethod = kPOST;
        request.requestSerializerType = kXMRequestSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        BATSearchBaseModel *searchBaseModel = [BATSearchBaseModel mj_objectWithKeyValues:responseObject];
        
        if (![searchBaseModel.resultCode isEqualToString:@"0"]) {
            //失败
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(error);
            }
            return ;
        }
        
        //成功
        if (success) {
            success(responseObject);
        }
        
    } onFailure:^(NSError *error) {
        
        if (failure) {
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
            failure(tmpError);
        }
        
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
}

@end
