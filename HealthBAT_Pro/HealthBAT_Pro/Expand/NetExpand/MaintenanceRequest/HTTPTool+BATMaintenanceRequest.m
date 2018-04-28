//
//  HTTPTool+BATMaintenanceRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATMaintenanceRequest.h"
#import "BATBaseModel.h"

@implementation HTTPTool (BATMaintenanceRequest)

+ (void)requestWithMaintenanceURLString:(NSString *)URLString
                             parameters:(id)parameters
                                   type:(XMHTTPMethodType)type
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError * error))failure {
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = MAINTENANCE_URL;
        request.api = URLString;
        request.parameters = parameters;
        if (LOGIN_STATION) {
            request.headers = @{@"Token":LOCAL_TOKEN};
        }
        request.httpMethod = type;
        request.requestSerializerType = kXMRequestSerializerJSON;
    } onSuccess:^(id responseObject) {
        
        BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (baseModel.ResultCode == -2) {
            //登录信息异常，走failure
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"LOGIN_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"登录状态异常，请重新登录",NSLocalizedFailureReasonErrorKey:@"Token无效或为空",NSLocalizedRecoverySuggestionErrorKey:@"重新登录"}];
                failure(error);
            }
            
            //需要登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
            return ;
        }
        
        if (baseModel.ResultCode != 0) {
            //数据异常失败，走failure方法
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:baseModel.ResultMessage,NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(error);
            }
            return ;
        }
        if (baseModel.ResultCode == 0) {
            //成功
            
            if (success) {
                success(responseObject);
            }
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
