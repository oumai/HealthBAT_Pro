//
//  HTTPTool+BATNetworkMedicalUploadImage.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATNetworkMedicalUploadImage.h"
#import "SVProgressHUD.h"
#import "BATKmApiconfigModel.h"
#import "BATNetworkMedicalAppTokenModel.h"

@implementation HTTPTool (BATNetworkMedicalUploadImage)

+ (void)requestUploadImageToKMWithParams:(NSArray *)dataArray
                                 success:(void(^)(NSArray *severImageArray))success
                                 failure:(void(^)(NSError *error))failure
                       fractionCompleted:(void(^)(double count))fractionCompleted
{
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {
        
        
        BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];
        
        NSString *URL = batKmApiconfigModel.Data.imgupload;
        
        dispatch_group_t group = dispatch_group_create();
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < dataArray.count; i++) {
            
            NSData *imageData = dataArray[i];
            
            dispatch_group_enter(group);
            
            NSString *baseID = [XMCenter sendRequest:^(XMRequest *request) {
                
                request.url = URL;
                request.requestType = kXMRequestUpload;
                request.headers = @{
                                    @"apptoken":batKmApiconfigModel.Data.apptoken,
                                    @"noncestr":batKmApiconfigModel.Data.noncestr,
                                    @"userid":batKmApiconfigModel.Data.userid,
                                    @"sign":batKmApiconfigModel.Data.sign,
                                    };
                

                [request addFormDataWithName:@"image[]" fileName:@"temp.jpg" mimeType:@"image/jpeg" fileData:imageData];

                
            } onProgress:^(NSProgress *progress) {
                
                
            } onSuccess:^(id responseObject) {
                
                if ([[responseObject objectForKey:@"Status"] integerValue] == 0) {
                    [array addObject:responseObject];
                }
                else {
                    
                    [XMCenter cancelRequest:baseID];
                }
                dispatch_group_leave(group);
                
            } onFailure:^(NSError *error) {
                
                
                [XMCenter cancelRequest:baseID];
                dispatch_group_leave(group);
                
            } onFinished:^(id responseObject, NSError *error) {
                
                
            }];
            
        }

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (array.count == dataArray.count) {
                if (success) {
                    success(array);
                }
            } else {
                if (failure) {
                    if (failure) {
                        failure(nil);
                    }
                }
            }
        });

        
    }failure:^(NSError *error) {
        
        if (failure) {
            if (failure) {
                failure(nil);
            }
        }
        
    }];
}



@end
