//
//  BATDrugOrderListModel.h
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
BATDrugOrderListDataModel,
BATDrugOrderListOPDRegisterModel,
BATDrugOrderListOrderModel,
BATDrugOrderListRecipeFilesModel,
BATDrugOrderListMember,
BATDrugOrderListDoctor;

@interface BATDrugOrderListModel : NSObject

@property (nonatomic, copy) NSArray<BATDrugOrderListDataModel *> *Data;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, assign) NSInteger Total;

@property (nonatomic, copy) NSString *Msg;

@end

@interface BATDrugOrderListDataModel : NSObject

@property (nonatomic, assign) BOOL Deletable;
@property (nonatomic, assign) BOOL Cancelable;

@property (nonatomic, strong) BATDrugOrderListOPDRegisterModel *OPDRegister;

@property (nonatomic, strong) BATDrugOrderListOrderModel *Order;

@property (nonatomic, copy) NSArray<BATDrugOrderListRecipeFilesModel *> *RecipeFiles;

@property (nonatomic, strong) BATDrugOrderListMember *Member;

@property (nonatomic, strong) BATDrugOrderListDoctor *Doctor;

@end

@interface BATDrugOrderListMember : NSObject

@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *IDType;
@property (nonatomic, copy) NSString *Relation;
@property (nonatomic, copy) NSString *Marriage;
@property (nonatomic, copy) NSString *Birthday;
@property (nonatomic, copy) NSString *IsDefault;
@property (nonatomic, assign) NSInteger Gender;
@property (nonatomic, copy) NSString *MemberID;
@property (nonatomic, copy) NSString *Age;
@property (nonatomic, copy) NSString *Identifier;
@property (nonatomic, copy) NSString *MemberName;

@end

@interface BATDrugOrderListDoctor : NSObject

@property (nonatomic, copy) NSString *IDType;
@property (nonatomic, copy) NSString *IsFollowed;
@property (nonatomic, copy) NSString *Marriage;
@property (nonatomic, copy) NSString *Sort;
@property (nonatomic, copy) NSString *DepartmentID;
@property (nonatomic, copy) NSString *IsExpert;
@property (nonatomic, copy) NSString *CheckState;
@property (nonatomic, copy) NSString *DiagnoseNum;
@property (nonatomic, copy) NSString *ConsulServicePrice;
@property (nonatomic, copy) NSString *ConsultNum;
@property (nonatomic, copy) NSString *DoctorID;
@property (nonatomic, copy) NSString *DoctorName;
@property (nonatomic, copy) NSString *Gender;
@property (nonatomic, copy) NSString *TitleName;
@property (nonatomic, copy) NSString *HospitalName;
@property (nonatomic, copy) NSString *DepartmentName;
@property (nonatomic, copy) NSString *HospitalID;
@property (nonatomic, copy) NSString *FollowNum;
@property (nonatomic, copy) NSString *IsFreeClinicr;
@property (nonatomic, copy) NSString *PhotoFullUrl;
@property (nonatomic, copy) NSString *IsConsultation;

@end

@interface BATDrugOrderListOPDRegisterModel : NSObject

@property (nonatomic, copy) NSString *OPDType;

@property (nonatomic, copy) NSString *OPDRegisterID;

@end

@interface BATDrugOrderListOrderModel : NSObject

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *TradeNo;

@property (nonatomic, assign) double TotalFee;

@property (nonatomic, assign) NSInteger OrderState;

@property (nonatomic, copy) NSString *OrderTime;

@property (nonatomic, assign) NSInteger LogisticState;

@end

@interface BATDrugOrderListRecipeFilesModel : NSObject

@property (nonatomic, assign) double Amount;

@property (nonatomic, copy) NSString *RecipeFileID;

@property (nonatomic, copy) NSString *RecipeName;

@property (nonatomic, copy) NSString *RecipeNo;

@property (nonatomic, copy) NSString *TCMQuantity;

@end

