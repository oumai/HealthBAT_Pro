//
//  BATNewsCommentModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class CommentData;
@interface BATNewsCommentModel : NSObject

@property (nonatomic, strong) NSArray<CommentData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface CommentData : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger Type;

@property (nonatomic, assign) NSInteger RelatedID;

@property (nonatomic, copy) NSString *Comment;

@property (nonatomic, copy) NSString *PicUrls;

@property (nonatomic, assign) NSInteger CreatedBy;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *UserName;

@end

