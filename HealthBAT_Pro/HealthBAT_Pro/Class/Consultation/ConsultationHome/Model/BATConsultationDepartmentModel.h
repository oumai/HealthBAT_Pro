//
//  BATDepartmentListModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class ConsultationDepartmentData;
@interface BATConsultationDepartmentModel : NSObject

@property (nonatomic, strong) NSArray<ConsultationDepartmentData *> *Data;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@end

@interface ConsultationDepartmentData : NSObject

@property (nonatomic, copy) NSString *CATNAME;

@property (nonatomic, assign) NSInteger CATDESC;

@property (nonatomic, copy) NSString *CAT_NO;

@property (nonatomic, copy) NSString * CONTENT;

@property (nonatomic, copy) NSString *CAT_ID;

@property (nonatomic, copy) NSString * Image;

@property (nonatomic, assign) NSInteger Sort;

@end
