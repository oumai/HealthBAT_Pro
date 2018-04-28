//
//  BATCourseModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATCourseData,ProjectVideoListData,ReplyListData;
@interface BATCourseModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATCourseData *> *Data;

@end

@interface BATCourseData : NSObject

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,copy) NSString *AttachmentUrl;

@property (nonatomic,assign) NSInteger Auditing;

@property (nonatomic,copy) NSString *AlbumID;

@property (nonatomic,copy) NSString *AlbumTitle;

@property (nonatomic,copy) NSString *AttachmentName;

@property (nonatomic,copy) NSString *AuditTime;

@property (nonatomic,assign) NSInteger Category;

@property (nonatomic,assign) NSInteger CollectNum;

@property (nonatomic,assign) NSInteger CourseType;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,copy) NSString *CoursePlayTime;

@property (nonatomic,copy) NSString *Description;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) BOOL IsFocus;

@property (nonatomic,assign) BOOL IsPageIndex;

@property (nonatomic,assign) BOOL IsSelect;

@property (nonatomic,assign) BOOL IsTestTemplate;

@property (nonatomic,assign) BOOL PageIndexSort;

@property (nonatomic,copy) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger PictureNum;

@property (nonatomic,copy) NSString *PictureUrl;

@property (nonatomic,copy) NSString *Poster;

@property (nonatomic, strong) NSMutableArray <ProjectVideoListData *> *ProjectVideoList;

@property (nonatomic,assign) NSInteger ReadingNum;

@property (nonatomic, strong) NSMutableArray <ReplyListData *> *ReplyList;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,copy) NSString *Signature;

@property (nonatomic,copy) NSString *TeacherName;

@property (nonatomic,copy) NSString *TeacherPhotoUrl;

@property (nonatomic,assign) NSInteger TemplateID;

@property (nonatomic,copy) NSString *Theme;

@property (nonatomic,copy) NSString *Time;

@property (nonatomic,copy) NSString *Topic;

@property (nonatomic,assign) NSInteger VideoCount;

@end


@interface ProjectVideoListData : NSObject

@end

@interface ReplyListData : NSObject

@end
