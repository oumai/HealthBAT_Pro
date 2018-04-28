//
//  BATTodayOfferModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HomeTodayOfferResultData;
@interface BATMallInfoModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) HomeTodayOfferResultData *resultData;

@end

@interface HomeTodayOfferResultData : NSObject

@property (nonatomic, assign) double discountPrice;

@property (nonatomic, assign) double marketPrice;

@property (nonatomic, copy) NSString *imgPath;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, copy) NSString *productName;

@end
