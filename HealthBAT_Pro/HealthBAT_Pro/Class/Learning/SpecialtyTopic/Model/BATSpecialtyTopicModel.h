//
//  BATSpecialtyCoursesModel.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATSpecialtyTopicData;
@interface BATSpecialtyTopicModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATSpecialtyTopicData *> *Data;

@end

@interface BATSpecialtyTopicData : NSObject

@property (nonatomic,assign) NSInteger ObjID;

@property (nonatomic,assign) NSInteger ObjType;

@property (nonatomic,copy) NSString *AlinkURL;

@property (nonatomic,copy) NSString *Description;

@property (nonatomic,copy) NSString *PictureURL;

@property (nonatomic,copy) NSString *Title;


@end
