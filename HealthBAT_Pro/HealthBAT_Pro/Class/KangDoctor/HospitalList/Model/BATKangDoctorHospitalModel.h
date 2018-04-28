//
//  BATKangDoctorHospitalModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATKangDoctorHospitalData;

@interface BATKangDoctorHospitalModel : NSObject

@property (nonatomic, assign) NSInteger       resultCode;

@property (nonatomic, copy  ) NSString        *msg;

@property (nonatomic, copy  ) NSArray<BATKangDoctorHospitalData *> *resultData;

@end


@interface BATKangDoctorHospitalData : NSObject

@property (nonatomic, copy  ) NSString        *address;

@property (nonatomic, copy  ) NSString        *geoDistance;

@property (nonatomic, copy  ) NSString        *hospitalAlias;

@property (nonatomic, assign) NSInteger       hospitalLevel;

@property (nonatomic, copy  ) NSString        *hospitalType;

@property (nonatomic, copy  ) NSString        *phone;

@property (nonatomic, copy  ) NSString        *pictureUrl;

@property (nonatomic, copy  ) NSString        *resultDesc;

@property (nonatomic, copy  ) NSString        *resultId;

@property (nonatomic, copy  ) NSString        *resultTitle;

@property (nonatomic, copy  ) NSString        *resultType;

@property (nonatomic, assign) NSInteger       score;

@property (nonatomic, copy  ) NSString        *url;

@end
