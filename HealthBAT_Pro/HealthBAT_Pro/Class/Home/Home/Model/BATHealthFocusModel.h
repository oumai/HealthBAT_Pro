//
//  BATHealthFocusModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/2/22.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATHomeHealthFocusData;

@interface BATHealthFocusModel : NSObject

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATHomeHealthFocusData *> *Data;

@end

@interface BATHomeHealthFocusData : NSObject

@property (nonatomic, copy  ) NSString          *CoursePlayTime;

@property (nonatomic, assign) NSInteger         ID;

@property (nonatomic, copy  ) NSString          *Poster;

@property (nonatomic, copy  ) NSString          *TeacherName;

@property (nonatomic, copy  ) NSString          *Topic;

@property (nonatomic, copy  ) NSString          *Description;

@property (nonatomic, assign) BATHealtFocusType Category;


@end
