//
//  DepartmentModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATDepartmentData;


@interface BATDepartmentModel : NSObject

@property (nonatomic, assign) NSInteger         PagesCount;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         RecordsCount;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATDepartmentData *> *Data;

@end


@interface BATDepartmentData : NSObject

@property (nonatomic, assign) NSInteger         DEP_ID;

@property (nonatomic, copy  ) NSString          *CAT_NO;

@property (nonatomic, copy  ) NSString          *DEP_INTRO;

@property (nonatomic, copy  ) NSString          *CAT_IMG;

@property (nonatomic, copy  ) NSString          *TREAT_LIMIT;

@property (nonatomic, assign) NSInteger         LEFT_NUM;

@property (nonatomic, copy  ) NSString          *CAT_NAME;

@property (nonatomic, copy  ) NSString          *DEP_NAME;

@property (nonatomic, assign) NSInteger         UNIT_ID;

@property (nonatomic, copy  ) NSString          *DEP_SPELL;

@property (nonatomic, copy  ) NSString          *HOSPITAL_POS;

@end

