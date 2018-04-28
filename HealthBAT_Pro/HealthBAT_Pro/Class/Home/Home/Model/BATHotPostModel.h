//
//  BATHotPostModel.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HotPostData;

@interface BATHotPostModel : NSObject

@property (nonatomic, strong) NSMutableArray<HotPostData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface HotPostData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *TopicID;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *PostContent;

@property (nonatomic, assign) NSInteger ReadNum;

@property (nonatomic, assign) NSInteger StarNum;

@property (nonatomic, assign) NSInteger ReplyNum;

@property (nonatomic, copy) NSString *ReplyTime;

@property (nonatomic, assign) NSInteger ReplyType;//判断类型

@property (nonatomic, assign) NSInteger ReportFlag;

@property (nonatomic, assign) NSInteger HotFlag;

@property (nonatomic, assign) NSInteger StatusFlag;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *AuditPerson;

@property (nonatomic, copy) NSString *AuditTime;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, assign) NSInteger Sex;

@property (nonatomic, copy) NSString *ImageList;

@property (nonatomic, assign) NSInteger IsSetStar;

@property (nonatomic, copy) NSString *ImageUrl;

@property (nonatomic, assign) NSInteger IsUserFollow;

@property (nonatomic, assign) NSInteger CategoryID;//废弃

@end


