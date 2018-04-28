//
//  BATRegistrationRecordModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATRegistrationRecordData;
@interface BATRegistrationRecordModel : NSObject

//@property (nonatomic,retain) NSString *name;        //用户 名字
//@property (nonatomic,retain) NSString *address;     //就诊位置
//@property (nonatomic,retain) NSString *phoneNum;    //电话号码
//@property (nonatomic,retain) NSString *docName;        // 医生名字
//@property (nonatomic,retain) NSString *begintime;    //挂号时间
//@property (nonatomic,retain) NSString *record_id;   //记录id
//@property (nonatomic,assign) int registerState; //挂号状态（已取消、未取消、已就诊）
//@property (nonatomic,retain) NSString *yuyue_id;        //预约成功才有，取消需要用到
////@property (nonatomic,assign) BOOL canCancel;       //是否可以取消
//@property (nonatomic,retain) NSString *toDate; //就诊日期
//@property (nonatomic,retain) NSString *OrderState;
//
//- (id)initWithHospitalDic:(NSDictionary *)hospitalDic;


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATRegistrationRecordData *> *Data;


@end
@interface BATRegistrationRecordData : NSObject

@property (nonatomic, assign) NSInteger YUYUE_ID;

@property (nonatomic, assign) NSInteger GUAHAO_AMT;

@property (nonatomic, copy) NSString *TIME_TYPE_DESC;

@property (nonatomic, copy) NSString *MEMBER_ID;

@property (nonatomic, copy) NSString *PAY_METHOD;

@property (nonatomic, copy) NSString *HIS_TAKE_NO;

@property (nonatomic, assign) NSInteger DEP_ID;

@property (nonatomic, copy) NSString *CARD;

@property (nonatomic, copy) NSString *DOCTOR_NAME;

@property (nonatomic, copy) NSString *DEP_NAME;

@property (nonatomic, copy) NSString *ORDER_NO;

@property (nonatomic, copy) NSString *HIS_MEM_ID;

@property (nonatomic, copy) NSString *TRUENAME;

@property (nonatomic, copy) NSString *SOCIAL_CARD;

@property (nonatomic, copy) NSString *ORDER_TIME;

@property (nonatomic, assign) NSInteger YUYUE_STATE;

@property (nonatomic, copy) NSString *TIME_TYPE;

@property (nonatomic, copy) NSString *END_TIME;

@property (nonatomic, assign) NSInteger DOCTOR_ID;

@property (nonatomic, copy) NSString *VisitAddress;

@property (nonatomic, copy) NSString *HIS_ORDER_NO;

@property (nonatomic, copy) NSString *PRINTED;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *UNIT_NAME;

@property (nonatomic, assign) BOOL CAN_CANCEL;

@property (nonatomic, copy) NSString *CITY_ID;

@property (nonatomic, assign) NSInteger UNIT_ID;

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *PHONE;

@property (nonatomic, copy) NSString *LEVEL_NAME;

@property (nonatomic, copy) NSString *TO_DATE;

@property (nonatomic, assign) NSInteger SEX;

@property (nonatomic, copy) NSString *VisitTime;

@property (nonatomic, copy) NSString *LEVEL_CODE;

@property (nonatomic, copy) NSString *BIRTH;

@property (nonatomic, copy) NSString *PayState;

@property (nonatomic, assign) NSInteger PAY_STATE;

@property (nonatomic, copy) NSString *OrderState;

@property (nonatomic, copy) NSString *BEGIN_TIME;

@end

