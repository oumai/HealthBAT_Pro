//
//  BATGroupDetailModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATGroupDetailData;
@interface BATGroupDetailModel : NSObject


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATGroupDetailData *Data;


@end
@interface BATGroupDetailData : NSObject

@property (nonatomic, copy) NSString *GroupIcon;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, assign) NSInteger MemberCount;

@property (nonatomic, assign) BOOL IsJoined;

@property (nonatomic, assign) NSInteger GroupTotal;

@property (nonatomic, copy) NSString *Members;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *GroupName;

@end

