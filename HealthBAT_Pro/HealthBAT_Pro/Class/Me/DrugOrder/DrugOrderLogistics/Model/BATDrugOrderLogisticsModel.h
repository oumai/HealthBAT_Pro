//
//  BATDrugOrderLogisticsModel.h
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDrugOrderLogisticsDataModel,BATDrugOrderLogisticsDetailsModel,BATDrugOrderLogisticsConsigneeModel;

@interface BATDrugOrderLogisticsModel : NSObject

@property (nonatomic, strong) BATDrugOrderLogisticsDataModel *Data;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, assign) NSInteger Total;

@property (nonatomic, copy) NSString *Msg;

@end

@interface BATDrugOrderLogisticsDataModel : NSObject

@property (nonatomic, copy) NSString *LogisticCompanyName;
@property (nonatomic, copy) NSArray<BATDrugOrderLogisticsDetailsModel *> *Details;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *OrderNo;
@property (nonatomic, copy) NSString *OrderType;
@property (nonatomic, copy) NSString *RefundState;
@property (nonatomic, copy) NSString *CancelReason;
@property (nonatomic, copy) NSString *StoreTime;
@property (nonatomic, copy) NSString *RefundTime;
@property (nonatomic, assign) NSInteger LogisticState;
@property (nonatomic, copy) NSString *FinishTime;
@property (nonatomic, assign) double TotalFee;
@property (nonatomic, copy) NSString *LogisticWayBillNo;
@property (nonatomic, copy) NSString *OrderOutID;
@property (nonatomic, copy) NSString *OrderState;
@property (nonatomic, copy) NSString *OrderExpireTime;
@property (nonatomic, copy) NSString *RefundFee;
@property (nonatomic, copy) NSString *TradeTime;
@property (nonatomic, copy) NSString *OrgnazitionID;
@property (nonatomic, copy) NSString *TradeNo;
@property (nonatomic, copy) NSString *IsEvaluated;
@property (nonatomic, copy) NSString *SellerID;
@property (nonatomic, copy) NSString *ExpressTime;
@property (nonatomic, copy) NSString *OrderTime;
@property (nonatomic, assign) NSInteger PayType;
@property (nonatomic, copy) NSString *CancelTime;
@property (nonatomic, copy) NSString *OriginalPrice;
@property (nonatomic, copy) NSString *LogisticNo;
@property (nonatomic, copy) NSString *CostType;
@property (nonatomic, copy) NSString *RefundNo;
@property (nonatomic, copy) NSString *Cancelable;
@property (nonatomic, strong) BATDrugOrderLogisticsConsigneeModel *Consignee;

@end

@interface BATDrugOrderLogisticsDetailsModel : NSObject

@property (nonatomic, copy) NSString *Discount;

@property (nonatomic, assign) double Fee;

@property (nonatomic, copy) NSString *ProductType;

@property (nonatomic, copy) NSString *UnitPrice;

@property (nonatomic, copy) NSString *Body;

@property (nonatomic, copy) NSString *Quantity;

@property (nonatomic, copy) NSString *ProductId;

@property (nonatomic, copy) NSString *Subject;

@end

@interface BATDrugOrderLogisticsConsigneeModel : NSObject

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Tel;

@property (nonatomic, copy) NSString *IsHosAddress;

@end
/*
 {
 "Total" : 0,
 "Msg" : "操作成功",
 "Status" : 0,
 "Result" : true,
 "Data" : {
 "LogisticCompanyName" : "",
 "Details" : [
 {
 "Discount" : 0,
 "Fee" : 0.16,
 "ProductType" : 4,
 "UnitPrice" : 0.16,
 "Body" : "中药处方",
 "Quantity" : 1,
 "ProductId" : "CC2017121816350002",
 "Subject" : "中药处方"
 }
 ],
 "UserID" : "244742",
 "OrderNo" : "TESTCF2017121911040001",
 "OrderType" : 4,
 "RefundState" : 0,
 "CancelReason" : "",
 "StoreTime" : "2017-12-19T16:58:15.8435044+08:00",
 "RefundTime" : "0001-01-01T00:00:00+08:00",
 "LogisticState" : -2,
 "FinishTime" : "0001-01-01T00:00:00+08:00",
 "TotalFee" : 0.16,
 "LogisticWayBillNo" : "",
 "OrderOutID" : "5aacb42f63cb4768b66a6f18c301e1c6",
 "OrderState" : 1,
 "OrderExpireTime" : "2017-12-22T11:04:13.0934886+08:00",
 "RefundFee" : 0,
 "TradeTime" : "2017-12-19T16:58:11.291244+08:00",
 "OrgnazitionID" : "kmwlyy",
 "TradeNo" : "2017121921001004670202924223",
 "IsEvaluated" : false,
 "SellerID" : "2088021337472610",
 "ExpressTime" : "0001-01-01T00:00:00+08:00",
 "OrderTime" : "2017-12-19T14:17:31.1668604+08:00",
 "PayType" : 2,
 "CancelTime" : "0001-01-01T00:00:00+08:00",
 "OriginalPrice" : 0.16,
 "LogisticNo" : "TD17121900027",
 "CostType" : 0,
 "RefundNo" : "",
 "Cancelable" : true,
 "Consignee" : {
 "Address" : "北京市,市辖区,东城区,Qweqweqweqeqewqw",
 "Name" : "qqwqeq",
 "Tel" : "13800138000",
 "IsHosAddress" : 0
 }
 }
 }
 */
