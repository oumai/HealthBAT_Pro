//
//  HTTPTool+BATKmWlyyRequest.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATKmWlyyRequest.h"
#import "BATKmApiconfigModel.h"
#import "BATKmWlyyBaseModel.h"

@implementation HTTPTool (BATKmWlyyRequest)

+ (void)requestWithKmWlyyBaseApiURLString:(NSString *)URLString
                               parameters:(id)parameters
                                     type:(XMHTTPMethodType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError * error))failure
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        [XMCenter sendRequest:^(XMRequest *request) {
            
            request.server = KM_WLYY_API;
            request.headers = @{
                                @"apptoken":batKmApiconfigModel.Data.apptoken,
                                @"noncestr":batKmApiconfigModel.Data.noncestr,
                                @"userid":batKmApiconfigModel.Data.userid,
                                @"sign":batKmApiconfigModel.Data.sign,
                                };
            
            request.api = URLString;
            request.parameters = parameters;
            request.httpMethod = type;
            request.requestSerializerType = kXMRequestSerializerJSON;
        } onSuccess:^(id responseObject) {
            
            BATKmWlyyBaseModel *baseModel = [BATKmWlyyBaseModel mj_objectWithKeyValues:responseObject];
            if (baseModel.Status != 0 && baseModel.Status != 1) {
                if (failure) {
                    NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:baseModel.Status userInfo:@{NSLocalizedDescriptionKey:baseModel.Msg,NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
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
        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}

+ (void)requestWithKmWlyyCommonApiURLString:(NSString *)URLString
                                 parameters:(id)parameters
                                       type:(XMHTTPMethodType)type
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError * error))failure
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        [XMCenter sendRequest:^(XMRequest *request) {
            
            request.server = KM_WLYY_COMMON_API;
            
            request.headers = @{
                                @"apptoken":batKmApiconfigModel.Data.apptoken,
                                @"noncestr":batKmApiconfigModel.Data.noncestr,
                                @"userid":batKmApiconfigModel.Data.userid,
                                @"sign":batKmApiconfigModel.Data.sign,
                                };
            
            request.api = URLString;
            request.parameters = parameters;
            request.httpMethod = type;
            request.requestSerializerType = kXMRequestSerializerJSON;
        } onSuccess:^(id responseObject) {
            
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
        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}
+ (void)requestWithKmWlyyYdApiURLString:(NSString *)URLString
                             parameters:(id)parameters
                                   type:(XMHTTPMethodType)type
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError * error))failure
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        [XMCenter sendRequest:^(XMRequest *request) {
            
            request.server = KM_WLYY_DRUGSTORE_API;
            request.headers = @{
                                @"apptoken":batKmApiconfigModel.Data.apptoken,
                                @"noncestr":batKmApiconfigModel.Data.noncestr,
                                @"userid":batKmApiconfigModel.Data.userid,
                                @"sign":batKmApiconfigModel.Data.sign,
                                };
            
            request.api = URLString;
            request.parameters = parameters;
            request.httpMethod = type;
            request.requestSerializerType = kXMRequestSerializerJSON;
        } onSuccess:^(id responseObject) {
            
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
        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}

+ (void)requestWithKmWlyyUserApiURLString:(NSString *)URLString
                               parameters:(id)parameters
                                     type:(XMHTTPMethodType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError * error))failure
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        [XMCenter sendRequest:^(XMRequest *request) {
            
            request.server = KM_WLYY_USER_API;
            request.headers = @{
                                @"apptoken":batKmApiconfigModel.Data.apptoken,
                                @"noncestr":batKmApiconfigModel.Data.noncestr,
                                @"userid":batKmApiconfigModel.Data.userid,
                                @"sign":batKmApiconfigModel.Data.sign,
                                };
            
            request.api = URLString;
            request.parameters = parameters;
            request.httpMethod = type;
            request.requestSerializerType = kXMRequestSerializerJSON;
        } onSuccess:^(id responseObject) {
            
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
        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}


+ (void)requestWithKmWlyyImageApiURLString:(NSString *)URLString
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError * error))failure
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        [XMCenter sendRequest:^(XMRequest *request) {
            
            request.url = URLString;
            request.headers = @{
                                @"apptoken":batKmApiconfigModel.Data.apptoken,
                                @"noncestr":batKmApiconfigModel.Data.noncestr,
                                @"userid":batKmApiconfigModel.Data.userid,
                                @"sign":batKmApiconfigModel.Data.sign,
                                };
            request.httpMethod = kGET;
            request.responseSerializerType = kXMResponseSerializerRAW;
            
        } onProgress:^(NSProgress *progress) {
            
        } onSuccess:^(id responseObject) {
            
            if (success) {
                success(responseObject);
            }
        } onFailure:^(NSError *error) {
            
            if (failure) {
                
                failure(error);
            }
        } onFinished:^(id responseObject, NSError *error) {
            
            
        }];
        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}

@end

