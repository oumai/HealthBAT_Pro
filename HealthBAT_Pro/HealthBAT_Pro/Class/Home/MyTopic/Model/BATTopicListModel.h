//
//  BATTopicListModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class MyTopicListDataModel;
@interface BATTopicListModel : NSObject

@property (nonatomic, strong) NSMutableArray<MyTopicListDataModel *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end


@interface MyTopicListDataModel : NSObject

@property (nonatomic, assign) NSInteger ConsultType;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *CategoryID;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *TopicImage;

@property (nonatomic, copy) NSString *FollowNum;

@property (nonatomic, copy) NSString *PostNum;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, assign) BOOL isAttend;

@property (nonatomic, assign) BOOL IsTopicFollow;

@end
