//
//  CityListModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATCityData;


@interface BATCityListModel : NSObject

@property (nonatomic, assign) NSInteger   PagesCount;

@property (nonatomic, assign) NSInteger   ResultCode;

@property (nonatomic, assign) NSInteger   RecordsCount;

@property (nonatomic, copy  ) NSString    *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATCityData *> *Data;

@end


@interface BATCityData : NSObject

@property (nonatomic, assign) NSInteger   CITY_ID;

@property (nonatomic, copy  ) NSString    *CITY_NAME;

@end

