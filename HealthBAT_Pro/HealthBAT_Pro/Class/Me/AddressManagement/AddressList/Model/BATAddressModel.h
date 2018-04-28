//
//  BATAddressModel.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATAddressData;

@interface BATAddressModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATAddressData *> *Data;

@end

@interface BATAddressData : NSObject

//@property (nonatomic, copy) NSString *ID;
//
//@property (nonatomic, assign) NSInteger AccountId;
//
//@property (nonatomic, copy) NSString *Name;
//
//@property (nonatomic, copy) NSString *CodePath;
//
//@property (nonatomic, copy) NSString *NamePath;
//
//@property (nonatomic, copy) NSString *Phone;
//
//@property (nonatomic, copy) NSString *Address;
//
//@property (nonatomic, copy) NSString *DoorNo;
//
//@property (nonatomic, assign) NSInteger CreatedBy;
//
//@property (nonatomic, copy) NSString *CreatedTime;
//
//@property (nonatomic, assign) NSInteger LastModifiedBy;
//
//@property (nonatomic, copy) NSString *LastModifiedTime;
//
//@property (nonatomic, assign) BOOL IsDefault;
//
//@property (nonatomic, assign) BOOL IsDeleted;

@property (nonatomic, copy) NSString *AddressID;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, assign) BOOL IsDefault;

@property (nonatomic, copy) NSString *ProvinceName;

@property (nonatomic, copy) NSString *CityName;

@property (nonatomic, copy) NSString *AreaName;

@property (nonatomic, copy) NSString *DetailAddress;

@end

