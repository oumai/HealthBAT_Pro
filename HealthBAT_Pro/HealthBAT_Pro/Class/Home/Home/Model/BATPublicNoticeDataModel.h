//
//  PublicNoticeDataModel.h
//  HealthBAT
//
//  Created by KM on 16/8/182016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class NoticeData;
@interface BATPublicNoticeDataModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NoticeData *Data;

@end

@interface NoticeData : NSObject

@property (nonatomic, strong) NSArray<NSString *> *NoticeList;

@end

