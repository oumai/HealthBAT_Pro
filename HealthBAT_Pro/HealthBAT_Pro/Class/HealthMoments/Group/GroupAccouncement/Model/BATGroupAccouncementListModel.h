//
//  BATGroupAccouncementListModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATGroupAccouncementListData;
@interface BATGroupAccouncementListModel : NSObject


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATGroupAccouncementListData *> *Data;


@end
@interface BATGroupAccouncementListData : NSObject

@property (nonatomic, copy) NSString *NoticeContent;

@property (nonatomic, assign) NSInteger AccountId;

@property (nonatomic, assign) BOOL IsDeleted;

@property (nonatomic, assign) NSInteger AccountType;

@property (nonatomic, assign) NSInteger GroupID;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *Creater;

@end

