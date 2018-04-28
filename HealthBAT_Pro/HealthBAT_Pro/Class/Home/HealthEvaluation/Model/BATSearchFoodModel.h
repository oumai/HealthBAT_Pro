//
//  BATSearchFoodModel.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
@class BATGetHealthFoodData;
@interface BATSearchFoodModel : NSObject
@property (nonatomic, copy) NSString *ResultMessage;
@property (nonatomic, assign) NSInteger ResultCode;

@property (strong, nonatomic) NSArray<BATHealthThreeSecondsRecommedFoodListModel *> *Data;
@property (nonatomic, assign) NSInteger RecordsCount;
@property (nonatomic, assign) NSInteger PageIndex;
@property (nonatomic, assign) NSInteger PageSize;

@end

//先忽略
@interface BATGetHealthFoodData : NSObject

@property (nonatomic, copy) NSString *MenuName;
@property (nonatomic, copy) NSString *HeatQty;
@property (nonatomic, copy) NSString *PictureURL;
@end
