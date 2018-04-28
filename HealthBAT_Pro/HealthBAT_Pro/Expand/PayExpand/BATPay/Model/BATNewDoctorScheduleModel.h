//
//  BATNewDoctorScheduleModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewDoctorScheduleData,NewDataWeek,NewScheduleTimeList;

@interface BATNewDoctorScheduleModel : NSObject

@property (nonatomic, strong) NSArray<NewDoctorScheduleData *> *Data;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, assign) NSInteger ResultCode;

@end


@interface NewDoctorScheduleData : NSObject

@property (nonatomic, strong) NewDataWeek *DataWeek;

@property (nonatomic, strong) NSArray *ScheduleTimeList;

@end


@interface NewDataWeek : NSObject

@property (nonatomic, copy) NSString *DateStr;

@property (nonatomic, copy) NSString *DateTime;

@property (nonatomic, copy) NSString *WeekStr;

@end

//@interface NewScheduleTimeList : NSObject
//
//@property (nonatomic, copy) NSString *EndTime;
//
//@property (nonatomic, copy) NSString *StartTime;
//
//@property (nonatomic, copy) NSString *ScheduleID;
//
//@property (nonatomic, assign) NSInteger IsLeftNum;
//
//@property (nonatomic, assign) NSInteger IsYueYue;
//
//@end

