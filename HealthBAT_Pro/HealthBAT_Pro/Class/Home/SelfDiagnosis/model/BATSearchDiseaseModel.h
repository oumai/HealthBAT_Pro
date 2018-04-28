//
//  BATSearchDiseaseModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/11/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class DiseaseData,DiseaseContent;

@interface BATSearchDiseaseModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) DiseaseData *resultData;

@end

@interface DiseaseData : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<DiseaseContent *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

@interface DiseaseContent : NSObject

@property (nonatomic, copy) NSString *commonSymptomList;

@property (nonatomic, copy) NSString *pictureUrl;

@property (nonatomic, copy) NSString *resultDesc;

@property (nonatomic, copy) NSString *resultId;

@property (nonatomic, copy) NSString *resultTitle;

@property (nonatomic, copy) NSString *resultType;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *symptoms;

@end
