//
//  BATTrainStudioCommentModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATTrainStudioCourseCommentData;

@interface BATTrainStudioCommentModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATTrainStudioCourseCommentData *> *Data;

@end


@interface BATTrainStudioCourseCommentData : NSObject

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,copy) NSString *Body;

@property (nonatomic,copy) NSString *CourseID;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *ParentId;

@property (nonatomic,copy) NSString *ParentLevelId;

@property (nonatomic,copy) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,copy) NSString *UserName;

@property (nonatomic,strong) NSMutableArray <BATTrainStudioCourseCommentData *> *secondReplyList;

@end
