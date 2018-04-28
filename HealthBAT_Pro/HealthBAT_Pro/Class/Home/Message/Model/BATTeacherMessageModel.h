//
//  BATTeacherMessageModel.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATTeacherMessagesData;
@interface BATTeacherMessageModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATTeacherMessagesData *> *Data;

@end

@interface BATTeacherMessagesData : NSObject

@property (nonatomic, assign) NSInteger         AccountID;

@property (nonatomic, copy  ) NSString          *AttachmentUrl;

@property (nonatomic, assign) NSInteger         Auditing;

@property (nonatomic, assign) NSInteger         Category;

@property (nonatomic, assign) NSInteger         CollectNum;

@property (nonatomic, assign) BATCourseType     CourseType;

@property (nonatomic, copy  ) NSString          *CreatedTime;

@property (nonatomic, copy  ) NSString          *Description;

@property (nonatomic, assign) NSInteger         ID;

@property (nonatomic, assign) BOOL              IsFocus;

@property (nonatomic, copy  ) NSString          *PhotoPath;

@property (nonatomic, copy  ) NSString          *Poster;

@property (nonatomic, assign) NSInteger         ReadingNum;

@property (nonatomic, assign) NSInteger         ReplyList;

@property (nonatomic, assign) NSInteger         ReplyNum;

@property (nonatomic, copy  ) NSString          *Signature;

@property (nonatomic, copy  ) NSString          *TeacherName;

@property (nonatomic, copy  ) NSString          *Topic;

@property (nonatomic, copy  ) NSString          *Month;

@property (nonatomic, copy  ) NSString          *PictureUrl;

@property (nonatomic, copy  ) NSString          *Time;

@property (nonatomic, assign) NSInteger         PictureNum;

@property (nonatomic, copy  ) NSString          *Week;

@property (nonatomic, copy  ) NSString          *TeacherPhotoUrl;
@end
