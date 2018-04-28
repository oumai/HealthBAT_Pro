//
//  BATUserPortrayTools.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATUserPortrayTools.h"
//#import "BATSearchBaseModel.h"
#import "Reachability.h"

@implementation BATUserPortrayTools
+ (BOOL)isExistenceSearchNetwork {
    BOOL isExistenceNetwork;
    NSString *searchDomain = SEARCH_URL;
    DDLogError(@"search_url---%@",[searchDomain substringFromIndex:7]);
    Reachability *reachability = [Reachability reachabilityWithHostName:[searchDomain substringFromIndex:7]];
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}

//用户游览操作
+ (void)saveUserBrowseRequestWithURL:(NSString *)URLString moduleName:(NSString *)moduleName moduleId:(NSString *)moduleId beginTime:(NSString *)beginTime browsePage:(NSString *)browsePage{
    
    if (moduleName == nil) {
        moduleName = @"";
    }
    if (beginTime == nil) {
        beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if (browsePage == nil) {
        browsePage = @"";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Tools getPostUUID] forKey:@"deviceNo"];
    [dict setValue:@(1) forKey:@"deviceType"];
    if (LOGIN_STATION) {
        [dict setValue:[Tools getCurrentID] forKey:@"userId"];
    }
    NSString *ipString = [Tools get4GorWIFIAddress];
    [dict setValue:ipString forKey:@"userIp"];
    [dict setValue:moduleName forKey:@"moduleName"];
    [dict setValue:moduleId forKey:@"moduleId"];
    [dict setValue:browsePage forKey:@"browsePage"];
    [dict setValue:beginTime forKey:@"startTime"];
    [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"leaveTime"];


    [HTTPTool requestWithSearchURLString:URLString parameters:dict success:^(id responseObject) {
          DDLogDebug(@"\nPOST返回值---\n==%@",responseObject);
    } failure:^(NSError *error) {

    }];

//    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    NSString * URL = [NSString stringWithFormat:@"%@/%@",SEARCH_URL,URLString];
//    
//    [manager POST:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//     //   id dic = [HTTPTool responseConfiguration:responseObject];
//        DDLogDebug(@"\nPOST返回值---\n");
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
//        DDLogWarn(@"\nPOST请求parameters－－－\n%@", [[[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding]);
//        
//    }];
}
//用户模块操作
+ (void)saveOperateModuleRequestWithURL:(NSString *)URLString pathName:(NSString *)pathName moduleId:(NSInteger)moduleId beginTime:(NSString *)beginTime{
    
    if (pathName == nil) {
        pathName = @"";
    }
    if (beginTime == nil) {
        beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Tools getPostUUID] forKey:@"deviceNo"];
    [dict setValue:@(1) forKey:@"deviceType"];
    if (LOGIN_STATION) {
        [dict setValue:[Tools getCurrentID] forKey:@"userId"];
    }
    NSString *ipString = [Tools get4GorWIFIAddress];
    [dict setValue:ipString forKey:@"userIp"];
    [dict setValue:pathName forKey:@"moduleName"];
    [dict setValue:@(moduleId) forKey:@"moduleId"];
    [dict setValue:beginTime forKey:@"createdTime"];
    [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"leaveTime"];

    [HTTPTool requestWithSearchURLString:URLString parameters:dict success:^(id responseObject) {
        
        DDLogDebug(@"\nPOST返回值---\n==%@",responseObject);
    } failure:^(NSError *error) {
        DDLogDebug(@"\nPOST返回值---\n==%@",error);
    }];

//    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    NSString * URL = [NSString stringWithFormat:@"%@/%@",SEARCH_URL,URLString];
//
//    [manager POST:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//     //   id dic = [HTTPTool responseConfiguration:responseObject];
//        DDLogDebug(@"\nPOST返回值---\n");
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
//        DDLogWarn(@"\nPOST请求parameters－－－\n%@", [[[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding]);
//        
//    }];
}
@end
