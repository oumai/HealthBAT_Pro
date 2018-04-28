//
//  BATChooseEntiyModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class MyResData;
@interface BATChooseEntiyModel : NSObject

@property (nonatomic, strong) NSArray<MyResData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface MyResData : NSObject

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *MemberName;

@property (nonatomic, copy) NSString *PostCode;

@property (nonatomic, copy) NSString *Email;

@property (nonatomic, assign) NSInteger IDType;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, assign) NSInteger Relation;

@property (nonatomic, assign) NSInteger Marriage;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, assign) BOOL IsDefault;

@property (nonatomic, assign) NSInteger Gender;

@property (nonatomic, copy) NSString *GenderName;

@property (nonatomic, assign) NSInteger Age;

@property (nonatomic, copy) NSString *Token;

@property (nonatomic, copy) NSString *MemberID;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *Weight;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, assign) BOOL IsPerfect;

@property (nonatomic, copy) NSString *Height;

@property (nonatomic, copy) NSString *Ages;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *Exercise; //锻炼
@property (nonatomic, copy) NSString *Sleep;  //睡眠质量
@property (nonatomic, copy) NSString *Dietary; //食欲不振
@property (nonatomic, copy) NSString *Mentality; //低落
@property (nonatomic, copy) NSString *Working; //按部就班

@end

