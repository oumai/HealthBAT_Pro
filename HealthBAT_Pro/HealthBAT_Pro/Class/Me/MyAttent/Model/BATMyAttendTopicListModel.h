//
//  BATMyAttendTopicListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATMyAttendTopicListModel;
@interface BATMyAttendTopicModel : NSObject
//RecordsCount = 3,
//ResultCode = 0,
//ResultMessage = 操作成功,
//Data = (
/** <#属性描述#> */
@property (nonatomic, copy)NSString *ResultMessage;
/** <#属性说明#> */
@property (nonatomic, assign)NSInteger RecordsCount;
/** <#属性说明#> */
@property (nonatomic, assign)NSInteger ResultCode;
/** <#属性描述#> */
@property (nonatomic,strong)NSArray <BATMyAttendTopicListModel *> *Data;
@end

@interface BATMyAttendTopicListModel : NSObject
//IsTopicFollow = 1,
//Remark = <null>,
//CategoryName = 聆听医生,
//Sort = 0,
//FollowNum = 0,
//PostNum = 0,
//CategoryID = 2,
//CreatedTime = 2017-03-22 19:51:21,
//TopicImage = http://upload.jkbat.com/Files/20170322/gzfci5ql.l0n.png,
//ID = 58d26539eeab792330ee1292,
//Topic = 医声

/** <#属性说明#> */
@property (nonatomic, copy) NSString *ID;
/** <#属性说明#> */
@property (nonatomic, assign) BOOL IsTopicFollow;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger Sort;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger FollowNum;
/** <#属性说明#> */
@property (nonatomic, assign) NSInteger PostNum;
/** <#属性说明#> */
@property (nonatomic,   copy) NSString *CategoryID;
/** <#属性描述#> */
@property (nonatomic ,  copy) NSString *CategoryName;
/** <#属性说明#> */
@property (nonatomic,   copy) NSString *CreatedTime;
/** <#属性说明#> */
@property (nonatomic,   copy) NSString *TopicImage;
/** <#属性描述#> */
@property (nonatomic,   copy) NSString *Topic;
@end
