//
//  BATMyProgrammesModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "BATProgramDetailModel.h"

@class ProgrammesData,BATProgramItem;
@interface BATMyProgrammesModel : NSObject

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<ProgrammesData *> *Data;

@end

@interface ProgrammesData : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *Theme;

@property (nonatomic, copy) NSString *TemplateImage;

@property (nonatomic, assign) BOOL IsFlag;

@property (nonatomic,assign) NSInteger EvaluationID;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic,assign) BOOL IsSecondDayOpenclock;

@property (nonatomic,assign) NSInteger TemplateID;

@property (nonatomic,strong) NSMutableArray <BATProgramItem *> *ProgrammeLst;

@end
