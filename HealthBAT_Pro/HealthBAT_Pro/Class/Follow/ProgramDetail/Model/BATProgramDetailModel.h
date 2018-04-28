//
//  BATProgramDetailModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATProgramDetailData,BATProgramItem,BATPlanItem,ProductList,BATClockInItem,BATRelevantSolutionItem;
@interface BATProgramDetailModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATProgramDetailData *Data;

@end

@interface BATProgramDetailData : NSObject

@property (nonatomic,assign) NSInteger TemplateID;

@property (nonatomic,copy) NSString *Theme;

@property (nonatomic,copy) NSString *TemplateImage;

@property (nonatomic,copy) NSString *ThemeResult;

@property (nonatomic,assign) BOOL IsFlag;

@property (nonatomic,assign) BOOL IsSelected;

@property (nonatomic,copy) NSString *Remark;

@property (nonatomic,assign) NSInteger EvaluationID;

@property (nonatomic,assign) NSInteger JoinCount;

@property (nonatomic,strong) NSString *SolutionsThat;

@property (nonatomic,assign) NSInteger ClockInCount;

@property (nonatomic,assign) NSInteger ALLClockInCount;

@property (nonatomic,assign) NSInteger ExpectClockInCount;

@property (nonatomic,assign) BOOL IsCanClockIn;

@property (nonatomic, assign) BOOL  IsSecondDayOpenclock;

@property (nonatomic,strong) NSMutableArray <BATProgramItem *> *ProgrammeLst;

@property (nonatomic,strong) NSMutableArray <BATPlanItem *> *PlanLst;

@property (nonatomic,strong) NSMutableArray <ProductList *> *ProductList;

@property (nonatomic,strong) NSMutableArray <BATClockInItem *> *ClockInList;

@property (nonatomic,strong) NSMutableArray <BATRelevantSolutionItem *> *RelevantSolutionList;
/** 打卡时间 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*ClockInTimeList;
/** 打卡格式化后的时间 */
@property (nonatomic, strong) NSMutableArray <NSDate *>*ClockInTimeListFormat;
/** 存放打卡时间中第一个和最后一个格式化后的时间 */
@property (nonatomic, strong) NSMutableArray <NSDate *>*ClockFirstAndLastDate;


@end

@interface BATProgramItem : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *JobTime;

@property (nonatomic,copy) NSString *Title;

@property (nonatomic,copy) NSString *ResultDesc;

@end

@interface ProductList : NSObject

@property (nonatomic,copy) NSString *Product_ID;

@property (nonatomic,copy) NSString *Sku_ID;

@property (nonatomic,copy) NSString *SALE_UNIT_PRICE;

@property (nonatomic,copy) NSString *MARKET_PRICE;

@property (nonatomic,copy) NSString *SKU_IMG_PATH;

@property (nonatomic,copy) NSString *PRODUCT_NAME;


@end

@interface BATPlanItem : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *Explain;

@end

@interface BATClockInItem : NSObject

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,copy) NSString *PhotoPath;

@end

@interface BATRelevantSolutionItem : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *Theme;

@property (nonatomic,copy) NSString *Remark;

@property (nonatomic,copy) NSString *TemplateImage;

@end
