//
//  BATTrainStudioCourseModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@class BATTrainStudioCourseData;

@interface BATTrainStudioCourseModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATTrainStudioCourseData   *> *Data;

@end


@interface BATTrainStudioCourseData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *Category;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *Poster;

@end
