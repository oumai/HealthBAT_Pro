//
//  HTTPTool.h
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMNetWorking.h"
#import "Reachability.h"

@interface HTTPTool : NSObject

+ (NetworkStatus)currentNetStatus;

+ (void)baseRequestWithURLString:(NSString *)URLString
                      parameters:(id)parameters
                            type:(XMHTTPMethodType)type
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError * error))failure;

@end
