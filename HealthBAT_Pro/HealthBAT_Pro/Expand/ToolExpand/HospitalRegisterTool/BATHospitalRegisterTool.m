//
//  HospitalRegisterTool.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHospitalRegisterTool.h"
#import "BATCityListModel.h"

@implementation BATHospitalRegisterTool

+ (void)getCityListWithSuccess:(void (^)(BATCityListModel * cityList))success
                       failure:(void (^)(NSError *error))failure {
    //获取支持的城市列表
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cityList.data"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        [HTTPTool requestWithURLString:@"/api/CityExternal/GetCityList" parameters:nil type:kGET success:^(id responseObject) {

            BATCityListModel * cityList = [BATCityListModel mj_objectWithKeyValues:responseObject];
            [NSKeyedArchiver archiveRootObject:cityList toFile:file];

            if (success) {
                success(cityList);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    else {
        BATCityListModel * cityList = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        if (success) {
            success(cityList);
        }
    }
}

+ (void)getArearListWithCity:(BATCityData *)city success:(void (^)(BATAreaModel * areaList))success failure:(void (^)(NSError *error))failure {
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/areaList.data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        [HTTPTool requestWithURLString:@"/api/CityExternal/GetAreaList"
                            parameters:@{
                                         @"parent_id":@(city.CITY_ID),
                                         @"page":@"",
                                         @"page_size":@""
                                         }
                                  type:kGET
                               success:^(id responseObject) {
                                   BATAreaModel * areaList = [BATAreaModel mj_objectWithKeyValues:responseObject];
                                   NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/areaList.data"];
                                   [NSKeyedArchiver archiveRootObject:areaList toFile:file];

                                   if (success) {
                                       success(areaList);
                                   }
                               }
                               failure:^(NSError *error) {
                                   if (failure) {
                                       failure(error);
                                   }
                               }];
    }
    else {
        BATAreaModel * areaList = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        if (success) {
            success(areaList);
        }
    }

}
@end
