//
//  BATHotTopicModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HotTopicData;
@interface BATHotTopicModel : NSObject

@property (nonatomic, strong) NSMutableArray<HotTopicData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic,assign) BOOL isTopic;

@end

@interface HotTopicData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *AccountID;

@property (nonatomic, copy) NSString *TopicID;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *PostContent;

@property (nonatomic, copy) NSString *ReadNum;

@property (nonatomic, assign) NSInteger StarNum;

@property (nonatomic, copy) NSString *ReplyNum;

@property (nonatomic, copy) NSString *ReplyTime;

@property (nonatomic, copy) NSString *ReportFlag;

@property (nonatomic, assign) NSInteger HotFlag;

@property (nonatomic, copy) NSString *StatusFlag;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *AuditPerson;

@property (nonatomic, copy) NSString *AuditTime;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic,assign) double collectionImageViewHeight;

@property (nonatomic,assign) double contentHeight;

@property (nonatomic,strong) NSArray *ImageList;

@property (nonatomic,assign) NSInteger IsSetStar;

@property (nonatomic,assign) NSInteger IsUserFollow;

@property (nonatomic,assign) BOOL isAudio;

@property (nonatomic,assign) NSInteger ReplyType;

/**
 *  显示时间还是话题标签判断
 */
@property (assign, nonatomic) BOOL isShowTime;

@property (nonatomic,assign) BOOL IsShow;



@end
