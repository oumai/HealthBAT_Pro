//
//  BATTopicDetailModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class topicDetailData;
@interface BATTopicDetailModel : NSObject

@property (nonatomic, strong) topicDetailData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end


@interface topicDetailData : NSObject

@property (nonatomic, assign) NSInteger CategoryID;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *FollowNum;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL IsTopicFollow;

@property (nonatomic, copy) NSString *PostNum;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *Sort;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *TopicImage;


@end
