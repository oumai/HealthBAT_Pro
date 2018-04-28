//
//  BATHealthyAssessModel.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BAtHealthYReturnData;
@class BaTHealthRecommendProduct;
@class EvaDetailListData;
@interface BATHealthyAssessModel : NSObject
@property (nonatomic, copy) NSString *ReturnMessage;
@property (nonatomic, assign) BOOL IsSuccess;
@property (strong, nonatomic) BAtHealthYReturnData *ReturnData;
@end

@interface BAtHealthYReturnData : NSObject
@property (nonatomic, assign) BOOL isEvalationSuccess;
@property (nonatomic, strong) NSArray *ErrorList;
@property (nonatomic, copy) NSString *UserName;
@property (assign, nonatomic) NSInteger TotalScore;
@property (nonatomic, assign) CGFloat BMI;
@property (nonatomic, copy) NSString *BMIStatus;
@property (nonatomic, strong) NSArray *DiagnosisList;
@property (nonatomic, strong) NSArray *SuggestList;
@property (nonatomic, strong) BaTHealthRecommendProduct  *RecommendProduct;
@property (nonatomic, strong) NSArray<EvaDetailListData *> *EvaDetailList;
@end
@interface BaTHealthRecommendProduct : NSObject
@property (nonatomic, copy) NSString *PRODUCT_NAME;
@property (nonatomic, copy) NSString *SKU_ID;
@property (nonatomic, copy) NSString *SKU_IMG_PATH;
@property (assign, nonatomic) NSInteger SALE_UNIT_PRICE;
@property (assign, nonatomic) NSInteger MARKET_PRICE;
@end

@interface EvaDetailListData: NSObject

@property (nonatomic, copy) NSString *EvaType;
@property (nonatomic, copy) NSString *Diagnosis;
@property (nonatomic, copy) NSString *Suggest;
@end
