//
//  BATCategoryListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATCategoryListModel : NSObject
/** <#属性描述#> */
@property (nonatomic, strong) NSString *Auditing;
@property (nonatomic, strong) NSString *ReadingNum;
@property (nonatomic, assign) BOOL IsSelect;
@property (nonatomic, assign) BOOL IsFocus;
@property (nonatomic, strong) NSString *Theme;
@property (nonatomic, strong) NSString *TemplateID;
@property (nonatomic, strong) NSString *AlbumID;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) BOOL IsTestTemplate;
@property (nonatomic, strong) NSString *AlbumTitle;
@property (nonatomic, assign) NSInteger  Category;
@property (nonatomic, strong) NSString *AttachmentUrl;
@property (nonatomic, assign) NSInteger  CourseType;
@property (nonatomic, strong) NSString  *TeacherName;
@property (nonatomic, strong) NSString  *Topic;
@property (nonatomic, strong) NSString  *Time;
@property (nonatomic, assign) NSInteger  CollectNum;
@property (nonatomic, strong) NSString  *CreatedTime;
@property (nonatomic, assign) NSInteger  AuditTime;
@property (nonatomic, strong) NSString  *TeacherPhotoUrl;
@property (nonatomic, strong) NSString  *AccountID;
@property (nonatomic, strong) NSString  *Description;
@property (nonatomic, strong) NSString  *AttachmentName;
@property (nonatomic, strong) NSString  *PhotoPath;
@property (nonatomic, strong) NSString  *Poster;
@property (nonatomic, strong) NSString  *CoursePlayTime;
@property (nonatomic, strong) NSString  *PictureNum;
@property (nonatomic, strong) NSString  *PictureUrl;
/** 专辑数 */
@property (nonatomic, strong) NSString *AlbumCount;
/** 是否是专辑 */
@property (nonatomic, assign) BOOL Isalbums;

@end
