//
//  BATPromoCodeModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/*
 优惠码model
 */
@class BATPrommoCodeData;

@interface BATPromoCodeModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATPrommoCodeData *> *Data;

@end

@interface BATPrommoCodeData : NSObject

@property (nonatomic, copy) NSString *Code;

@property (nonatomic, assign) BOOL IsUser;

@property (nonatomic, assign) BOOL IsTerm;

@property (nonatomic, copy) NSString *Scope;

@property (nonatomic, copy) NSString *TermTime;


@end
