//
//  BATHomeOnlineStudyModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/12/82016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATHomeOnlineStudyData;

@interface BATHomeOnlineStudyModel : NSObject

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATHomeOnlineStudyData *> *Data;

@end


@interface BATHomeOnlineStudyData : NSObject


@property (nonatomic, copy  ) NSString          *Title;

@property (nonatomic, copy  ) NSString          *PictureURL;

@property (nonatomic, copy  ) NSString          *Description;

@property (nonatomic, copy  ) NSString          *AlinkURL;

@property (nonatomic, assign) BATCourseType     ObjType;

@property (nonatomic, assign) NSInteger         ObjID;

@end


