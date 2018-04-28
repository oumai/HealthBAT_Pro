//
//  BATMemberInfoModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/18.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATMemberInfoData;
@interface BATMemberInfoModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATMemberInfoData *Data;


@end

@interface BATMemberInfoData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *AccountId;
 //状态 0:未购买 1：有效，2：到期
@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, copy) NSString *ExpireTime;

@end
