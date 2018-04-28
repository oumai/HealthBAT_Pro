//
//  BATProgrammesTypeCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProgrammesType;

@interface BATProgrammesTypeModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<ProgrammesType *> *Data;

@end

@interface ProgrammesType : NSObject

@property (nonatomic, copy) NSString *CategoryID;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, assign) BOOL isSelect;


@end
