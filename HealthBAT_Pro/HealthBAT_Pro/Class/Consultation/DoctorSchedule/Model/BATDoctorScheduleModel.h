//
//  BATDoctorScheduleModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorScheduleData,Dateweeklist,Schedulelist,Regnumlist;
@interface BATDoctorScheduleModel : NSObject


@property (nonatomic, strong) DoctorScheduleData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;


@end
@interface DoctorScheduleData : NSObject

@property (nonatomic, strong) NSArray<Dateweeklist *> *DateWeekList;

@property (nonatomic, strong) NSArray<Schedulelist *> *ScheduleList;

@property (nonatomic, copy) NSString *DoctorId;

@end

@interface Dateweeklist : NSObject

@property (nonatomic, copy) NSString *DateStr;

@property (nonatomic, copy) NSString *WeekStr;

@end

@interface Schedulelist : NSObject

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, strong) NSArray<Regnumlist *> *RegNumList;

@property (nonatomic, copy) NSString *StartTime;

@end

@interface Regnumlist : NSObject

@property (nonatomic, assign) NSInteger RegSum;

@property (nonatomic, assign) NSInteger RegNum;

@property (nonatomic, copy) NSString *DoctorScheduleID;

@end

