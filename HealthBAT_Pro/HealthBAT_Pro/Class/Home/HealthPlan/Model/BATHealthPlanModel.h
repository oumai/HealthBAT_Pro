//
//  BATHealthPlanModel.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HealthPlanVideData,Video;
@interface BATHealthPlanModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy) NSArray<HealthPlanVideData *> *Data;

@end

@interface HealthPlanVideData : NSObject

@property (nonatomic, strong) NSArray<Video *> *VideoLst;

@property (nonatomic, copy) NSString *PictureURL;

@property (nonatomic, copy) NSString *TypeName;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger SortNumber;

@end

@interface Video : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *PictureURL;

@property (nonatomic, assign) NSInteger SportTypeID;

@property (nonatomic, copy) NSString *VideoAddress;

@property (nonatomic, copy) NSString *VideoName;

@end
