//
//  BATHotTopicListModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HotTopicListData;

@interface BATHotTopicListModel : NSObject

@property (nonatomic, strong) NSMutableArray<HotTopicListData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;


@end


@interface HotTopicListData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *CategoryID;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *TopicImage;

@property (nonatomic, copy) NSString *FollowNum;

@property (nonatomic, copy) NSString *PostNum;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL IsTopicFollow;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *Sort;

@property (nonatomic,strong) NSString *AccountID;

@property (nonatomic, assign) BOOL IsShowBtn;

@end
