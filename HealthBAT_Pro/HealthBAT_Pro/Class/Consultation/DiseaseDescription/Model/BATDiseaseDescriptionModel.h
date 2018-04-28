//
//  DiseaseDescriptionModel.h
//  HealthBAT
//
//  Created by cjl on 16/8/4.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class DiseaseDescriptionData;
@interface BATDiseaseDescriptionModel : NSObject

@property (nonatomic, strong) DiseaseDescriptionData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;


@end

@interface DiseaseDescriptionData : NSObject

@property (nonatomic, copy) NSString *ActionStatus;

@property (nonatomic, copy) NSString *ErrorInfo;

@property (nonatomic, copy) NSString *UserConsultID;

@property (nonatomic, copy) NSString *OPDRegisterID;

@property (nonatomic, copy) NSString *OrderNO;

@property (nonatomic, assign) NSInteger OrderState;

@end

//@class Attachent,ConsultChatRecord;
//@interface BATDiseaseDescriptionModel : NSObject
//
///**
// *  医生ID
// */
//@property (nonatomic, assign) NSInteger DoctorAccountID;
//
//@property (nonatomic, assign) NSInteger OrderStatus;
//
///**
// *  咨询状态
// */
//@property (nonatomic, assign) NSInteger ConsultStatus;
//
//@property (nonatomic, strong) NSArray<Attachent *> *AttachentList;
//
//@property (nonatomic, strong) NSArray<ConsultChatRecord *> *ConsultChatRecord;
//
///**
// *  咨询类型
// */
//@property (nonatomic, assign) NSInteger ConsultType;
//
///**
// *  病人ID
// */
//@property (nonatomic, assign) NSInteger PatientAccountID;
//
///**
// *  病症描述
// */
//@property (nonatomic, copy) NSString *DiseaseDescription;
//
///**
// *  想要什么帮助
// */
//@property (nonatomic, copy) NSString *DoctorHelp;
//
//
//@property (nonatomic, assign) NSInteger Payment;
//
///**
// *  结束时间
// */
//@property (nonatomic, strong) NSString * LastModifiedTime;
//
///**
// *  支付时间
// */
//@property (nonatomic, strong) NSString *PayTime;
///**
// *  咨询ID
// */
//@property (nonatomic, assign) NSInteger ID;
//
///**
// *  价钱
// */
//@property (nonatomic, assign) NSInteger PayMoney;
//
//@end
//
//@interface Attachent : NSObject
//
//@property (nonatomic, copy) NSString *AttachmentUrl;
//
//@property (nonatomic, copy) NSString *AttachmentName;
//
//@property (nonatomic, copy) NSString *AttachAilas;
//
//@end
//
//@interface ConsultChatRecord : NSObject
//
//@property (nonatomic, assign) NSInteger ConsultRecordID;
//
//@property (nonatomic, assign) NSInteger UserType;
//
//@property (nonatomic, copy) NSString *Content;
//
//@property (nonatomic, copy) NSString *PhotoPath;
//
//@property (nonatomic, copy) NSString *UserName;
//
//@property (nonatomic, copy) NSString *CreatedTime;
//
//@property (nonatomic, assign) NSInteger MessageType;
//
//@end

