//
//  BATTrainStudioCourseDetailModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATTrainStudioCourseDetailData;

@interface BATTrainStudioCourseDetailModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATTrainStudioCourseDetailData *Data;

@end


@interface BATTrainStudioCourseDetailData : NSObject

@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *AccountId;

@property (nonatomic,copy) NSString *TeacherName;

@property (nonatomic,copy) NSString *TeacherDesc;

@property (nonatomic,assign) NSInteger CourseCategory;

@property (nonatomic,copy) NSString *CourseCategoryAlias;

@property (nonatomic,copy) NSString *CourseTitle;

@property (nonatomic,copy) NSString *CourseDesc;

@property (nonatomic,assign) NSInteger CourseType;

@property (nonatomic,assign) NSInteger ClassHour;

@property (nonatomic,copy) NSString *Poster;

@property (nonatomic,copy) NSString *AttachmentUrl;

@property (nonatomic,assign) NSInteger ReadingNum;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,assign) NSInteger CollectNum;

@property (nonatomic,assign) NSInteger Auditing;

@property (nonatomic,copy) NSString *AuditingAlias;

@property (nonatomic,copy) NSString *AuditContent;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,copy) NSString *MainContent;

//@property (nonatomic,assign) NSInteger CollectNum;
//
//@property (nonatomic,assign) NSInteger CourseType;

//@property (nonatomic,copy) NSString *CreatedTime;
//
//@property (nonatomic,copy) NSString *Description;
//
//@property (nonatomic,assign) NSInteger ID;
//
//@property (nonatomic,assign) BOOL IsFocus;
//
//@property (nonatomic,copy) NSString *PhotoPath;
//
//@property (nonatomic,copy) NSString *Poster;
//
//@property (nonatomic,assign) NSInteger ReadingNum;
//
//@property (nonatomic,assign) NSInteger ReplyNum;
//
//@property (nonatomic,copy) NSString *Signature;
//
//@property (nonatomic,copy) NSString *TeacherName;
//
//@property (nonatomic,copy) NSString *Topic;
//
//@property (nonatomic,strong) NSMutableArray <BATCourseCommentData *> *ReplyList;
//
//@property (nonatomic,assign) BOOL IsTestTemplate;
//
//@property (nonatomic,assign) NSInteger TemplateID;
//
//@property (nonatomic,copy) NSString *Theme;

@end

