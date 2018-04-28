//
//  BATTopicSearchModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TopicResultData,TopicSearchBody,TopicSearchContent;

@interface BATTopicSearchModel : NSObject

@property (nonatomic,strong) NSString *msg;

@property (nonatomic,assign) NSInteger resultCode;

@property (nonatomic,strong) NSMutableArray<TopicResultData *> *resultData;


@end

@interface TopicResultData : NSObject

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) TopicSearchBody *body;

@end

@interface TopicSearchBody : NSObject

@property (nonatomic,assign) NSInteger number;

@property (nonatomic,strong) NSMutableArray<TopicSearchContent *> *content;

@property (nonatomic,strong) NSString *numberOfElements;

@property (nonatomic,strong) NSString *sort;

@property (nonatomic,strong) NSString *totalPages;

@property (nonatomic,strong) NSString *size;

@property (nonatomic,strong) NSString *last;

@property (nonatomic,assign) NSInteger totalElements;

@property (nonatomic,strong) NSString *first;

@end

@interface TopicSearchContent : NSObject

@property (nonatomic,strong) NSString *resultDesc;

@property (nonatomic,strong) NSString *resultTitle;

@property (nonatomic,strong) NSString *score;

@property (nonatomic,strong) NSString *resultType;

@property (nonatomic,strong) NSString *resultId;

@property (nonatomic,strong) NSString *photoPath;

@property (nonatomic,strong) NSString *topicImage;
@end

