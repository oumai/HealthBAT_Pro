//
//  AreaModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATAreaData;

@interface BATAreaModel : NSObject

@property (nonatomic, assign) NSInteger   PagesCount;

@property (nonatomic, assign) NSInteger   ResultCode;

@property (nonatomic, assign) NSInteger   RecordsCount;

@property (nonatomic, copy  ) NSString    *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATAreaData *> *Data;

@end


@interface BATAreaData : NSObject

@property (nonatomic, assign) NSInteger   AREA_ID;

@property (nonatomic, copy  ) NSString    *AREA_NAME;

@property (nonatomic, assign) NSInteger   PARENT_ID;

@property (nonatomic, assign) NSInteger   AREA_LEVEL;

@property (nonatomic, assign) NSInteger   CITY_ID;

@end

