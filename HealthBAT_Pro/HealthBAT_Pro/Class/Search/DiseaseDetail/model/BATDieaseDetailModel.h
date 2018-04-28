//
//  BATDieaseDetailModel.h
//  TableViewTest
//
//  Created by kmcompany on 16/9/20.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class ResData,Aboutdiseaselst,Drugslst;
@interface BATDieaseDetailModel : NSObject

@property (nonatomic, strong) ResData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface ResData : NSObject

@property (nonatomic, copy) NSString *Inspection_Detail;

@property (nonatomic, copy) NSString *Common_Symptom_Desc;

@property (nonatomic, copy) NSString *Susceptible_Population;

@property (nonatomic, copy) NSString *Disease_Name;

@property (nonatomic, copy) NSString *Briefintro_Content;

@property (nonatomic, copy) NSString *Cure_Rate;

@property (nonatomic, copy) NSString *Nursing_Detail;

@property (nonatomic, copy) NSString *Treatment_Detail;

@property (nonatomic, strong) NSArray<Drugslst *> *Drugslst;

@property (nonatomic, copy) NSString *Dept_Name;

@property (nonatomic, strong) NSMutableArray<Aboutdiseaselst *> *AboutDiseaselst;

@property (nonatomic, copy) NSString *Concurrent_Disease_Nlist;

@end

@interface Aboutdiseaselst : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *Name;

@end

@interface Drugslst : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *Name;

@end

