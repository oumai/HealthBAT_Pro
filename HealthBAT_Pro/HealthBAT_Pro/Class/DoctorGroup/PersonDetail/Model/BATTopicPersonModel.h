//
//  BATTopicPersonModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TopicPersonModelData;

@interface BATTopicPersonModel : NSObject

@property (nonatomic, strong) TopicPersonModelData  *Data;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;


@end

@interface TopicPersonModelData : NSObject

@property (nonatomic, copy) NSString *AccountID;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *PostNum;

@property (nonatomic, copy) NSString *TopicNum;

@property (nonatomic, copy) NSString *FollowNum;

@property (nonatomic, copy) NSString *FansNum;

@property (nonatomic, assign) BOOL IsUserFollow;

@property (nonatomic, assign) BOOL IsShow;

@end
