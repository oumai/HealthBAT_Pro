//
//  BATTemplateModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATTemplateData,BATQuestion,BATQuestionAnswerItem;
@interface BATTemplateModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATTemplateData *Data;

@end

@interface BATTemplateData : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *Theme;

@property (nonatomic,copy) NSString *TemplateImage;

@property (nonatomic,copy) NSString *Remark;

@property (nonatomic,strong) NSMutableArray <BATQuestion *> *Questionlst;

@end

@interface BATQuestion : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger Sort;

@property (nonatomic,copy) NSString *Question;

@property (nonatomic,strong) NSMutableArray <BATQuestionAnswerItem *> *QuestionItemLst;

@end

@interface BATQuestionAnswerItem : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *Item;

@property (nonatomic,assign) NSInteger ItemScore;

@property (nonatomic,assign) BOOL isSelect;

@end
