//
//  BATMyAttendUserListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATMyAttendUserListModel;

@interface BATMyAttendUserModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATMyAttendUserListModel *> *Data;

@end


@interface BATMyAttendUserListModel : NSObject
//IsShow = 0,
//TopicNum = 6,
//FollowNum = 10,
//Sex = 0,
//PostNum = 15,
//IsUserFollow = 0,
//AccountID = 2422,
//UserName = 我是小乖乖,
//PhotoPath = http://upload.jkbat.com/Files/20170307/ganybbih.5fs.jpg,
//FansNum = 13



/** 1 当前登录用户查看自己的关注列表   当前用户查看其它用户的关注列表 */
@property (nonatomic ,assign) BOOL isAttend;
/**本人：1互相    0 关注   其他人：1已经关注 0 未关注*/
@property (nonatomic ,assign) BOOL IsUserFollow;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *UserName;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *FansNum;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *PhotoPath;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *AccountID;



/** <#属性描述#> */
@property (nonatomic ,assign) BOOL Sex;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *FollowNum;

/** <#属性描述#> */
@property (nonatomic ,copy) NSString *TopicNum;

/** <#属性描述#> */
@property (nonatomic ,assign) BOOL IsShow;

@end


