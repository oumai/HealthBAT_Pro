//
//  BATWeChatPayOrderInfoModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeChatPayData;
@interface BATWeChatPayOrderInfoModel : NSObject


@property (nonatomic, strong) WeChatPayData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;


@end
@interface WeChatPayData : NSObject

@property (nonatomic, copy) NSString *nonce_str;

@property (nonatomic, copy) NSString *partnerId;

@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, copy) NSString *package;

@property (nonatomic, copy) NSString *prepay_id;

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *sign;

@end

