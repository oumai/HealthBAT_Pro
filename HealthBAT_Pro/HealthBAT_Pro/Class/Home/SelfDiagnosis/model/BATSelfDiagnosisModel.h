//
//  BATSelfDiagnosisModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/10/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class DiagnoisiData,Partscategorylist,Partsitemlist,Dislist;
@interface BATSelfDiagnosisModel : NSObject

@property (nonatomic, strong) DiagnoisiData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface DiagnoisiData : NSObject

@property (nonatomic, strong) NSArray<Partscategorylist *> *partsCategoryList;

@end

@interface Partscategorylist : NSObject

@property (nonatomic, strong) NSArray<Partsitemlist *> *partsItemList;

@property (nonatomic, copy) NSString *Name;

@end

@interface Partsitemlist : NSObject

@property (nonatomic, copy) NSString *ItemName;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSArray<Dislist *> *disList;

@end

@interface Dislist : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *DisName;

@end

