//
//  BATAlbumDetailCommentModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATAlbumDetailCommentData;

@interface BATAlbumDetailCommentModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATAlbumDetailCommentData *> *Data;

@end

@interface BATAlbumDetailCommentData : NSObject

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,copy) NSString *AccountName;

@property (nonatomic,copy) NSString *Body;

@property (nonatomic,assign) NSInteger CourseID;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) BOOL IsFocus;

@property (nonatomic,copy) NSString *PhotoPath;

@property (nonatomic,strong) NSMutableArray <BATAlbumDetailCommentData *> *SubCourseReplyList;

@property (nonatomic,copy) NSString *Topic;

@property (nonatomic,assign) NSInteger StarCount;

@property (nonatomic,assign) NSInteger ReplyNum;

@property (nonatomic,copy) NSString *ReplyTime;

@property (nonatomic,copy) NSString *ReplyAccountName;

@property (nonatomic,assign) NSInteger ParentId;

@property (nonatomic, assign) double          commentTableViewHeight;

@property (nonatomic, assign) double          commentHeight;

@end
