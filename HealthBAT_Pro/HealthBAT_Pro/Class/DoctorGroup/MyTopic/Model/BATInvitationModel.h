//
//  BATInvitationModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class InvitationData,InvitationDataImage;

@interface BATInvitationModel : NSObject

@property (nonatomic,strong) InvitationData *Data;

@property (nonatomic,strong) NSString *ResultCode;

@property (nonatomic,strong) NSString *ResultMessage;

@end

@interface InvitationData : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *AccountID;

@property (nonatomic,strong) NSString *TopicID;

@property (nonatomic,strong) NSString *Topic;

@property (nonatomic,strong) NSString *Title;

@property (nonatomic,strong) NSString *PostContent;

@property (nonatomic,assign) NSInteger ReadNum;

@property (nonatomic,assign) NSInteger StarNum;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,strong) NSString *ReplyTime;

@property (nonatomic,assign) NSInteger ReportFlag;

@property (nonatomic,assign) NSInteger HotFlag;

@property (nonatomic,assign) NSInteger StatusFlag;

@property (nonatomic,strong) NSString *CreatedTime;

@property (nonatomic,strong) NSString *AuditPerson;

@property (nonatomic,strong) NSString *AuditTime;

@property (nonatomic,strong) NSString *UserName;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger Sex;

@property (nonatomic,assign) BOOL IsUserFollow;

@property (nonatomic,assign) BOOL IsSetStar;

@property (nonatomic,strong) NSMutableArray <InvitationDataImage *> *ImageList;

@property (nonatomic,assign) double collectionImageViewHeight;

@end

@interface InvitationDataImage : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *ImageSize;

@property (nonatomic,strong) NSString *ImageUrl;

@property (nonatomic,strong) NSString *PostID;

@property (nonatomic,strong) NSString *Sort;

@end
