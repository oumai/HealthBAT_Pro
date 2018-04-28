//
//  BATRecommendNewsListModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/18.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATRecommendNewsData;
@interface BATRecommendNewsListModel : NSObject

@property (nonatomic, strong) NSMutableArray<BATRecommendNewsData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface BATRecommendNewsData : NSObject

@property (nonatomic, copy) NSString *MainImage;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *ReadingQuantity;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *CategoryId;

@property (nonatomic, copy) NSString *ReleaseTime;

@property (nonatomic, copy) NSString *LastModifiedTime;

@end
