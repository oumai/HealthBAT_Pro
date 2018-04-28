//
//  BATRecommendGroupModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATRecommendGroupData;
@interface BATRecommendGroupModel : NSObject


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATRecommendGroupData *> *Data;


@end
@interface BATRecommendGroupData : NSObject

@property (nonatomic, copy) NSString *GroupIcon;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, assign) NSInteger MemberCount;

@property (nonatomic, assign) BOOL IsJoined;

@property (nonatomic, assign) NSInteger GroupTotal;

@property (nonatomic, strong) NSArray *Members;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *GroupName;

@end

