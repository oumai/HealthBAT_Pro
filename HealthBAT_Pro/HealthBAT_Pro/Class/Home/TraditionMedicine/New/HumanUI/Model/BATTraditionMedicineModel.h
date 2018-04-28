//
//  BATTraditionMedicineModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/3/282017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATTraditionMedicineData;
@interface BATTraditionMedicineModel : NSObject

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) BATTraditionMedicineData *Data;

@end

@interface BATTraditionMedicineData : NSObject

@property (nonatomic, assign) NSInteger DoctorAccountID;

@property (nonatomic, strong) NSString  *DoctorName;

@property (nonatomic, assign) NSInteger PatientAccountID;

@property (nonatomic, copy) NSString *ChannelID;

@end
