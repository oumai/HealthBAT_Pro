//
//  BATTraditonMedicineModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATTraditonMedicineModel : NSObject

@property (nonatomic,assign) NSInteger AccountID;
@property (nonatomic,assign) CGFloat Height;
@property (nonatomic,assign) CGFloat Weight;
@property (nonatomic,copy) NSString *BodyStatus;
@property (nonatomic,copy) NSString *HealthResult;

@end
