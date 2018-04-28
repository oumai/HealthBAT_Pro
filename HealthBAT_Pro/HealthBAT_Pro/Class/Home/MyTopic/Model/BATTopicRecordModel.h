//
//  BATTopicReplyModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TopicReplyData,secondReplyData;

@interface BATTopicRecordModel : NSObject

@property (nonatomic,strong) NSString *RecordsCount;

@property (nonatomic,strong) NSString *ResultCode;

@property (nonatomic,strong) NSString *ResultMessage;

@property (nonatomic,strong) NSMutableArray<TopicReplyData *> *Data;

@end

@interface TopicReplyData : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) NSString *PostID;

@property (nonatomic,strong) NSString *CourseID;

@property (nonatomic,strong) NSString *AccountID;

@property (nonatomic,strong) NSString *ReplyType;

@property (nonatomic,strong) NSString *Body;

@property (nonatomic,strong) NSString *ReplyContent;

@property (nonatomic,strong) NSString *AudioUrl;

@property (nonatomic,strong) NSString *AudioLong;

@property (nonatomic,strong) NSString *ReadNum;

@property (nonatomic,assign) NSInteger StarNum;

@property (nonatomic,strong) NSString *ReplyNum;

@property (nonatomic,strong) NSString *CreatedTime;

@property (nonatomic,strong) NSString *UserName;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,strong) NSString *Sex;

@property (nonatomic,assign) BOOL IsSetStar;

@property (nonatomic,strong) NSMutableArray<secondReplyData *> *secondReplyList;

@property (nonatomic, assign) double          commentTableViewHeight;



@end

@interface secondReplyData : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) NSString *PostID;

@property (nonatomic,strong) NSString *AccountID;

@property (nonatomic,strong) NSString *CourseID;

@property (nonatomic,strong) NSString *ReplyType;

@property (nonatomic,strong) NSString *Body;

@property (nonatomic,strong) NSString *ReplyContent;

@property (nonatomic,strong) NSString *AudioUrl;

@property (nonatomic,strong) NSString *AudioLong;

@property (nonatomic,strong) NSString *CreatedTime;

@property (nonatomic,strong) NSString *UserName;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,strong) NSString *Sex;

@property (nonatomic, assign) double          commentHeight;

@end
