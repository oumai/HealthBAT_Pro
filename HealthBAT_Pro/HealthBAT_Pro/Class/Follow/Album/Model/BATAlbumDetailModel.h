//
//  BATAlbumDetailModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATAlbumDetailData,BATAlbumCommentData,BATAlbumProjectVideoData;

@interface BATAlbumDetailModel : NSObject

@property (nonatomic, copy) NSString *ResultMessage;
@property (nonatomic, assign) NSInteger ResultCode;
@property (nonatomic, strong) BATAlbumDetailData *Data;
@end


@interface BATAlbumDetailData : NSObject

@property (nonatomic,assign)    NSInteger Auditing;
@property (nonatomic,copy)      NSString *AuditTime;
@property (nonatomic,copy)      NSString *Theme;
@property (nonatomic,copy)      NSString *AlbumID;
@property (nonatomic,copy)      NSString *AlbumTitle;
@property (nonatomic,copy)      NSString *AttachmentUrl;
@property (nonatomic,copy)      NSString *AttachmentName;
@property (nonatomic,assign)    NSInteger AccountID;
@property (nonatomic,assign)    NSInteger CourseType;
@property (nonatomic,assign)    NSInteger Category;
@property (nonatomic,copy)      NSString *CreatedTime;
@property (nonatomic,assign)    NSInteger CoursePlayTime;
@property (nonatomic,assign)    NSInteger CollectNum;
@property (nonatomic,copy)      NSString *Description;
@property (nonatomic,assign)    NSInteger ID;
@property (nonatomic,assign)    BOOL IsFocus;
@property (nonatomic,assign)    NSInteger IsPageIndex;
@property (nonatomic,assign)    NSInteger IsTestTemplate;
@property (nonatomic,assign)    NSInteger PageIndexSort;
@property (nonatomic,assign)    NSInteger PictureNum;
@property (nonatomic,copy)      NSString *PhotoPath;
@property (nonatomic,copy)      NSString *Poster;
@property (nonatomic,strong)    NSMutableArray <BATAlbumProjectVideoData *> *ProjectVideoList;
@property (nonatomic,strong)    NSMutableArray <BATAlbumCommentData *> *ReplyList;
@property (nonatomic,assign)    NSInteger ReplyNum;
@property (nonatomic,assign)    NSInteger ReadingNum;
@property (nonatomic,copy)      NSString *Signature;
@property (nonatomic,assign)    NSInteger TemplateID;
@property (nonatomic,copy)      NSString *Topic;
@property (nonatomic,copy)      NSString *TeacherName;
@property (nonatomic,copy)      NSString *Time;
@property (nonatomic,copy)      NSString *TeacherPhotoUrl;
@property (nonatomic,assign)    NSInteger VideoCount;
@end



@interface BATAlbumCommentData : NSObject

@end

@interface BATAlbumProjectVideoData : NSObject

@property (nonatomic,copy)      NSString *Title;
@property (nonatomic,assign)    NSInteger VideoID;
@property (nonatomic,assign)    NSInteger VideoSortBy;
@property (nonatomic,copy)      NSString *Name;
@property (nonatomic,copy)      NSString *Poster;
@property (nonatomic,copy)      NSString *TemplateID;
@property (nonatomic,copy)      NSString *TemplateName;
/** 记录是否点击 */
@property (nonatomic, assign) BOOL  selected;

@end
