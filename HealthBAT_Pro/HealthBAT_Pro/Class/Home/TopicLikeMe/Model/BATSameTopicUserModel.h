//
//  BATSameTopicUserModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class sameTopicUserData;

@interface BATSameTopicUserModel : NSObject

@property (nonatomic, strong) NSMutableArray<sameTopicUserData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface sameTopicUserData : NSObject

@property (nonatomic, copy) NSString *AccountID;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *PostNum;

@property (nonatomic, copy) NSString *TopicNum;

@property (nonatomic, copy) NSString *FollowNum;

@property (nonatomic, copy) NSString *FansNum;

@property (nonatomic, assign) BOOL IsUserFollow;

@property (nonatomic, copy) NSString *IsShow;

@end
