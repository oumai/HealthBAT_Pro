//
//  BATRegisterCancelModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/10/282016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATRegisterCancelData;
@interface BATRegisterCancelModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATRegisterCancelData *Data;

@end

@interface BATRegisterCancelData : NSObject

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, assign) NSInteger ResultCode;


@end

