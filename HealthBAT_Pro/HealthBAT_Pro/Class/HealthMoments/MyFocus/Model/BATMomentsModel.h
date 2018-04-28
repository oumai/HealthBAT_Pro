//
//  MomentsModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATMomentData,BATComments,BATMarkhelpfuls,BATImglist;

@interface BATMomentsModel : NSObject

@property (nonatomic, assign) NSInteger       PageIndex;

@property (nonatomic, assign) NSInteger       PageSize;

@property (nonatomic, assign) NSInteger       PagesCount;

@property (nonatomic, assign) NSInteger       ResultCode;

@property (nonatomic, assign) NSInteger       RecordsCount;

@property (nonatomic, copy  ) NSString        *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATMomentData   *> *Data;

@end


@interface BATMomentData : NSObject

@property (nonatomic, copy  ) NSString        *ID;
//是否隐藏评论
@property (nonatomic, assign) BOOL            IsHideCommon;

@property (nonatomic, assign) BOOL            IsMaster;

@property (nonatomic, assign) BOOL            IsFavorite;

@property (nonatomic, assign) BOOL            MarkHelpful;

@property (nonatomic, copy  ) NSString        *DynamicTitle;


@property (nonatomic, assign) NSInteger       MyUpdateID __deprecated_msg("已废弃");

@property (nonatomic, copy  ) NSString        *Signature;

@property (nonatomic, copy  ) NSString        *CreatedTime;

@property (nonatomic, strong) NSMutableArray<BATComments     *> *Comments;

@property (nonatomic, assign) NSInteger       Count;

@property (nonatomic, copy  ) NSString        *UserName;

@property (nonatomic, assign) NSInteger       AccountID;

@property (nonatomic, copy  ) NSString        *DynamicImg;

@property (nonatomic, assign) NSInteger       Sex;

@property (nonatomic, copy  ) NSString        *PhotoPath;

@property (nonatomic, copy  ) NSString        *Address;

@property (nonatomic, assign) NSInteger       CAccountID;

@property (nonatomic, assign) NSInteger       CommentCount;

@property (nonatomic, assign) NSInteger       AccountType;

@property (nonatomic, copy  ) NSString        *DynamicContent;

@property (nonatomic, copy  ) NSArray<BATMarkhelpfuls *> *MarkHelpfuls;

@property (nonatomic, copy  ) NSString        *GroupName;

@property (nonatomic, assign) NSInteger       GroupID;

@property (nonatomic, copy  ) NSArray<BATImglist      *> *imgList;

@property (nonatomic, copy  ) NSString        *MentionedUsers;

@property (nonatomic, assign) NSInteger       DynamicID;

@property (nonatomic, assign) NSInteger       CategoryID __deprecated_msg("已废弃，改用PostType");

@property (nonatomic, assign) NSInteger       MarkHelpfulCount;

@property (nonatomic, assign) NSInteger       PatientID __deprecated_msg("已废弃");

@property (nonatomic, assign) NSInteger       BizRecordID __deprecated_msg("已废弃");

@property (nonatomic, assign) double          collectionImageViewHeight;

@property (nonatomic, assign) double          commentTableViewHeight;


//新增参数

@property (nonatomic, copy  ) NSString        *PostId;

@property (nonatomic, assign) NSInteger       PostType;

@property (nonatomic, assign) NSInteger       FansNum;

@property (nonatomic, assign) NSInteger       FollowNum;

@property (nonatomic, assign) BOOL            IsBindQQ;

@property (nonatomic, assign) BOOL            IsBindWX;

@property (nonatomic, assign) NSInteger       MyFollowCount __deprecated_msg("已废弃");

//新增参数
@property (nonatomic, assign) NSInteger       IsCollect;

@property (nonatomic, assign) NSInteger       IsHot;

@end



@interface BATComments : NSObject

@property (nonatomic, copy  ) NSString        *CreatedTime;

@property (nonatomic, copy  ) NSString        *LastModifiedTime;

@property (nonatomic, copy  ) NSString        *MyCommentAttachments;

@property (nonatomic, copy  ) NSString        *BizRecordType;

@property (nonatomic, assign) NSInteger       AccountID;

@property (nonatomic, copy  ) NSString        *CommentContent;

@property (nonatomic, copy  ) NSString        *ID;

@property (nonatomic, copy  ) NSString        *AccountLevel;

@property (nonatomic, copy  ) NSString        *UserName;

@property (nonatomic, copy  ) NSString        *PhotoPath;

@property (nonatomic, assign) NSInteger       AccountType;

@property (nonatomic, assign) NSInteger       BizRecordID __deprecated_msg("已废弃");

@property (nonatomic, copy  ) NSString        *ParentCommentID;

@property (nonatomic, assign) NSInteger       MarkHelpfulCount;

@property (nonatomic, assign) NSInteger       MyUpdateID __deprecated_msg("已废弃");

@property (nonatomic, assign) BOOL            IsMaster;

@property (nonatomic, copy  ) NSArray         *Comments;

@property (nonatomic, assign) BOOL            MarkHelpful;

@property (nonatomic, copy  ) NSString        *MyCommentMentionedAccounts;

@property (nonatomic, assign) double          commentHeight;

//新增参数
@property (nonatomic, copy  ) NSString        *PostId;

@end



@interface BATMarkhelpfuls : NSObject

@property (nonatomic, assign) NSInteger       BizRecordID;

@property (nonatomic, assign) BOOL            IsHelpful;

@property (nonatomic, assign) BOOL            IsMaster;

@property (nonatomic, copy  ) NSString        *ID;

@property (nonatomic, assign) NSInteger       AccountID;

@property (nonatomic, copy  ) NSString        *UserName;

@property (nonatomic, copy  ) NSString        *BizRecordType;

@property (nonatomic, copy  ) NSString        *PhotoPath;

@property (nonatomic, assign) NSInteger       AccountType;

@property (nonatomic, assign) NSInteger       MyFollowCount;

@end



@interface BATImglist : NSObject

@property (nonatomic, copy  ) NSString        *groupName;

@property (nonatomic, copy  ) NSString        *imgs;

@property (nonatomic, copy  ) NSString        *postId;

@property (nonatomic, copy  ) NSString        *ID;

@property (nonatomic, copy  ) NSString        *ImageSize;

@property (nonatomic, copy  ) NSString        *ImageUrl;

@property (nonatomic, copy  ) NSString        *PostID;

@property (nonatomic, copy  ) NSString        *Sort;

@end

