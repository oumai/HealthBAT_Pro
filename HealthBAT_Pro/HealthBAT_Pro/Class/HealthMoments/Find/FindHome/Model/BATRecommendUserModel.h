//
//  BATRecommendUserModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATRecommendUserData;
@interface BATRecommendUserModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATRecommendUserData *> *Data;

@end
@interface BATRecommendUserData : NSObject

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *AccountLevel;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, assign) NSInteger GroupID;

@property (nonatomic, copy) NSString *Introduction;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, assign) NSInteger AccountType;

@property (nonatomic, assign) BOOL IsFollowed;

@property (nonatomic, assign) NSInteger FriendsCount;

@property (nonatomic, assign) BOOL IsMaster;

@property (nonatomic, assign) NSInteger FollowersCount;

@property (nonatomic, assign) NSInteger Sex;

@property (nonatomic, copy) NSString *Signature;

@property (nonatomic, assign) BOOL IsMe;

@end

