//
//  BATGroupAccouncementModel.h
//  HealthBAT
//
//  Created by KM on 16/7/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATGroupAccouncementData;
@interface BATGroupAccouncementModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATGroupAccouncementData *Data;

@end

@interface BATGroupAccouncementData : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *NoticeContent;

@property (nonatomic, assign) NSInteger GroupID;

@property (nonatomic, assign) BOOL IsDeleted;

@end

