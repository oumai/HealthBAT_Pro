//
//  BATOrderChatModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class OrderResData,Usermember,Room,Doctor,Doctorservices,Order,User,Messages;
@interface BATOrderChatModel : NSObject

@property (nonatomic, strong) NSMutableArray<OrderResData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface OrderResData : NSObject

@property (nonatomic, copy) NSString *AnswerTime;

@property (nonatomic, copy) NSString *MemberID;

@property (nonatomic, strong) Usermember *UserMember;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, strong) User *User;

@property (nonatomic, copy) NSString *FinishTime;

@property (nonatomic, strong) NSArray<Messages *> *Messages;

@property (nonatomic, copy) NSString *ConsultContent;

@property (nonatomic, assign) NSInteger ConsultType;

@property (nonatomic, copy) NSString *ConsultTime;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, copy) NSString *Files;

@property (nonatomic, strong) Room *Room;

@property (nonatomic, strong) Order *Order;

@property (nonatomic, copy) NSString *UserConsultID;

@property (nonatomic, strong) Doctor *Doctor;

@property (nonatomic, assign) NSInteger ConsultState;

@end

@interface Usermember : NSObject

@property (nonatomic, copy) NSString *Mobile;

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

@property (nonatomic, copy) NSString *MemberID;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *MemberName;

@end

@interface Room : NSObject

@property (nonatomic, copy) NSString *Secret;

@property (nonatomic, assign) NSInteger TotalTime;

@property (nonatomic, copy) NSString *BeginTime;

@property (nonatomic, assign) NSInteger RoomState;

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, copy) NSString *ConversationRoomID;

@property (nonatomic, assign) NSInteger ChannelID;

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, copy) NSString *ServiceID;

@end

@interface Doctor : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, assign) NSInteger IDType;

@property (nonatomic, copy) NSString *Duties;

@property (nonatomic, assign) NSInteger Marriage;

@property (nonatomic, assign) NSInteger Sort;

@property (nonatomic, copy) NSString *DepartmentID;

@property (nonatomic, copy) NSString *PostCode;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, assign) BOOL IsExpert;

@property (nonatomic, copy) NSString *Intro;

@property (nonatomic, assign) NSInteger CheckState;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, strong) NSArray<Doctorservices *> *DoctorServices;

@property (nonatomic, assign) NSInteger ScheduleCount;

@property (nonatomic, assign) NSInteger Gender;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *Hospital;

//@property (nonatomic, copy) NSString *User;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *Grade;

@property (nonatomic, copy) NSString *DoctorClinic;

@property (nonatomic, copy) NSString *HospitalID;

@property (nonatomic, copy) NSString *Education;

@property (nonatomic, copy) NSString *SignatureURL;

@property (nonatomic, copy) NSString *areaCode;

@property (nonatomic, assign) BOOL IsConsultation;

@property (nonatomic, copy) NSString *Specialty;

@property (nonatomic, copy) NSString *Department;

@property (nonatomic, strong) User *User;

@end

@interface Doctorservices : NSObject

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, assign) NSInteger ServicePrice;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, assign) NSInteger ServiceSwitch;

@property (nonatomic, copy) NSString *ServiceID;

@end

@interface Order : NSObject

@property (nonatomic, copy) NSString *Details;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, assign) NSInteger OrderType;

@property (nonatomic, assign) NSInteger RefundState;

@property (nonatomic, copy) NSString *CancelReason;

@property (nonatomic, copy) NSString *StoreTime;

@property (nonatomic, copy) NSString *RefundTime;

@property (nonatomic, assign) NSInteger LogisticState;

@property (nonatomic, copy) NSString *FinishTime;

@property (nonatomic, assign) double TotalFee;

@property (nonatomic, copy) NSString *OrderOutID;

@property (nonatomic, assign) NSInteger OrderState;

@property (nonatomic, copy) NSString *SellerID;

@property (nonatomic, copy) NSString *RefundFee;

@property (nonatomic, copy) NSString *TradeTime;

@property (nonatomic, copy) NSString *TradeNo;

@property (nonatomic, copy) NSString *ExpressTime;

@property (nonatomic, copy) NSString *OrderTime;

@property (nonatomic, assign) NSInteger PayType;

@property (nonatomic, copy) NSString *CancelTime;

@property (nonatomic, copy) NSString *LogisticNo;

@property (nonatomic, copy) NSString *RefundNo;

@property (nonatomic, copy) NSString *Consignee;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *PayPassword;

@property (nonatomic, copy) NSString *UserAccount;

@property (nonatomic, assign) NSInteger Checked;

@property (nonatomic, assign) NSInteger UserLevel;

@property (nonatomic, copy) NSString *PhotoUrl;

@property (nonatomic, copy) NSString *Password;

@property (nonatomic, assign) NSInteger Score;

@property (nonatomic, assign) NSInteger Good;

@property (nonatomic, assign) NSInteger Comment;

@property (nonatomic, copy) NSString *Answer;

@property (nonatomic, copy) NSString *RegTime;

@property (nonatomic, copy) NSString *UserCNName;

@property (nonatomic, copy) NSString *UserENName;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *Question;

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, copy) NSString *Email;

@property (nonatomic, assign) NSInteger Star;

@property (nonatomic, assign) NSInteger Grade;

@property (nonatomic, assign) NSInteger Fans;

@property (nonatomic, copy) NSString *CancelTime;

@property (nonatomic, copy) NSString *LastTime;

@property (nonatomic, assign) NSInteger UserType;

@property (nonatomic, assign) NSInteger Terminal;

@property (nonatomic, assign) NSInteger UserState;

@end

@interface Messages : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *MessageType;

@property (nonatomic, copy) NSString *MessageContent;

@property (nonatomic, copy) NSString *ConversationMessageID;

@property (nonatomic, assign) NSInteger MessageState;

@property (nonatomic, assign) NSInteger ConversationRoomID;

@property (nonatomic, copy) NSString *MessageTime;

@property (nonatomic, copy) NSString *ServiceID;

@end

