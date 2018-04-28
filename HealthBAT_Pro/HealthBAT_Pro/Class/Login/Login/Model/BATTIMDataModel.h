//
//  BATTIMDataModel.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TIMData;

@interface BATTIMDataModel : NSObject

@property (nonatomic, assign) NSInteger    ResultCode;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, strong) TIMData      *Data;

@end

@interface TIMData : NSObject

@property (nonatomic, copy)     NSString *userSig;

@property (nonatomic, copy)     NSString *sdkAppID;

@property (nonatomic, copy)     NSString *identifier;

@property (nonatomic, copy)     NSString *accountType;

@end
