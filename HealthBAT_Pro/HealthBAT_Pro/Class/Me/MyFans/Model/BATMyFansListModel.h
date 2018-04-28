//
//  BATMyFansListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATMyFansListModel : NSObject

@property (nonatomic,copy) NSString *AccountID;

@property (nonatomic,strong) NSString *UserName;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger Sex;

@property (nonatomic,assign) NSInteger PostNum;

@property (nonatomic,assign) NSInteger TopicNum;

@property (nonatomic,assign) NSInteger FollowNum;

@property (nonatomic,assign) NSInteger FansNum;

@property (nonatomic,assign) BOOL IsUserFollow;

@property (nonatomic,assign) BOOL IsAttned;

@property (nonatomic,assign) NSInteger IsShow;

@property (nonatomic,assign) BOOL IsShowBtn;


@end

@interface BATMyFansSubModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATMyFansListModel *> *Data;
@end
