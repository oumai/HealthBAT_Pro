//
//  BATDrKangIntroductionModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class DrKangIntroductionResultdata;

@interface BATDrKangIntroductionModel : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, strong) DrKangIntroductionResultdata *resultData;

@end

@interface DrKangIntroductionResultdata : NSObject

@property (nonatomic,copy) NSArray *body;
@property (nonatomic,strong) NSString *type;

@end

