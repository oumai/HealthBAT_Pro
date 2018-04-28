//
//  BATOTCOrderDetailModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATOTCConfirmOrderData,DetailModel,ConsigneeModel;
@interface BATOTCOrderDetailModel : NSObject

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         Status;

@property (nonatomic, assign) NSInteger         Total;

@property (nonatomic, strong) BATOTCConfirmOrderData *Data;

@end

@interface BATOTCConfirmOrderData : NSObject

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *TradeNo;

@property (nonatomic, copy) NSString *OrderOutID;

@property (nonatomic, copy) NSString *LogisticNo;

@property (nonatomic, assign) NSInteger PayType;

@property (nonatomic, assign) NSInteger OrderType;

@property (nonatomic, assign) NSInteger OrderState;

@property (nonatomic, assign) NSInteger RefundState;

@property (nonatomic, assign) NSInteger LogisticState;

@property (nonatomic, copy) NSString *OrderTime;

@property (nonatomic, copy) NSString *TradeTime;

@property (nonatomic, copy) NSString *CancelTime;

@property (nonatomic, copy) NSString *CancelReason;

@property (nonatomic, copy) NSString *FinishTime;

@property (nonatomic, copy) NSString *StoreTime;

@property (nonatomic, copy) NSString *ExpressTime;

@property (nonatomic, copy) NSString *RefundTime;

@property (nonatomic, copy) NSString *RefundFee;

@property (nonatomic, assign) double TotalFee;

@property (nonatomic, strong) NSArray<DetailModel *> *Details;

@property (nonatomic, strong) ConsigneeModel *Consignee;

@end

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *Subject;

@property (nonatomic, copy) NSString *Body;

@property (nonatomic, copy) NSString *UnitPrice;

@property (nonatomic, assign) NSInteger Quantity;

@property (nonatomic, assign) double Fee;

@property (nonatomic, copy) NSString *Discount;

@property (nonatomic, copy) NSString *ProductId;

@property (nonatomic, assign) NSInteger ProductType;

@end

@interface ConsigneeModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Tel;

@end
