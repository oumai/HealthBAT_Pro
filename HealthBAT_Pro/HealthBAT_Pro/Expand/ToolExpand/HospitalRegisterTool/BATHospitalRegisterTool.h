//
//  HospitalRegisterTool.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BATCityListModel.h"
#import "BATAreaModel.h"

@interface BATHospitalRegisterTool : NSObject

+ (void)getCityListWithSuccess:(void (^)(BATCityListModel * cityList))success
                       failure:(void (^)(NSError *error))failure;

+ (void)getArearListWithCity:(BATCityData *)city success:(void (^)(BATAreaModel * areaList))success failure:(void (^)(NSError *error))failure;

@end
