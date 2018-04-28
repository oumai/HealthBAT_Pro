//
//  BATCourseDetailModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATCourseDetailData,BATCourseCommentData;
@interface BATCourseDetailModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATCourseDetailData *Data;

@end

@interface BATCourseDetailData : NSObject

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,copy) NSString *AttachmentUrl;

@property (nonatomic,assign) NSInteger Auditing;

@property (nonatomic,assign) NSInteger Category;

@property (nonatomic,assign) NSInteger CollectNum;

@property (nonatomic,assign) NSInteger CourseType;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,copy) NSString *Description;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) BOOL IsFocus;

@property (nonatomic,copy) NSString *PhotoPath;

@property (nonatomic,copy) NSString *Poster;

@property (nonatomic,assign) NSInteger ReadingNum;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,copy) NSString *Signature;

@property (nonatomic,copy) NSString *TeacherName;

@property (nonatomic,copy) NSString *Topic;

@property (nonatomic,strong) NSMutableArray <BATCourseCommentData *> *ReplyList;

@property (nonatomic,assign) BOOL IsTestTemplate;

@property (nonatomic,assign) NSInteger TemplateID;

@property (nonatomic,copy) NSString *Theme;

@end
