//
//  HealthAssessmentModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATAssessmentData;

@interface BATHealthAssessmentModel : NSObject

@property (nonatomic, assign) NSInteger         PagesCount;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         RecordsCount;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATAssessmentData *> *Data;

@end


@interface BATAssessmentData : NSObject

@property (nonatomic, copy  ) NSString          *CreatedBy;

@property (nonatomic, copy  ) NSString          *EvaluationTempQuesList;

@property (nonatomic, copy  ) NSString          *LastModifiedTime;

@property (nonatomic, copy  ) NSString          *ThemeDesc;

@property (nonatomic, copy  ) NSString          *ThemeIcon;

@property (nonatomic, assign) NSInteger         EvaluatedCount;

@property (nonatomic, copy  ) NSString          *LastModifiedBy;

@property (nonatomic, assign) NSInteger         Category;

@property (nonatomic, copy  ) NSString          *CreatedTime;

@property (nonatomic, assign) NSInteger         ID;

@property (nonatomic, assign) NSInteger         Count;

@property (nonatomic, copy  ) NSString          *Flag;

@property (nonatomic, copy  ) NSString          *IndexButtonColor;

@property (nonatomic, copy  ) NSString          *IndexButtonFontColor;

@property (nonatomic, copy  ) NSString          *NumberFontColor;

@property (nonatomic, copy  ) NSString          *OptionBgColor;

@property (nonatomic, copy  ) NSString          *OptionColor;

@property (nonatomic, copy  ) NSString          *QuestionFontColor;

@property (nonatomic, copy  ) NSString          *ResultButtonColor;

@property (nonatomic, copy  ) NSString          *ResultButtonFontColor;

@property (nonatomic, copy  ) NSString          *ResultFontColor;

@property (nonatomic, copy  ) NSString          *ScoreColor;

@property (nonatomic, assign) NSInteger         Sort;

@property (nonatomic, copy  ) NSString          *Theme;

@property (nonatomic, copy  ) NSString          *ThemeBgImg;

@property (nonatomic, copy  ) NSString          *ThemeCoverImg;

@property (nonatomic, copy  ) NSString          *Token;

@end

