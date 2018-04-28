//
//  BATPunchCardModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATPunchCardItem;
@interface BATPunchCardModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATPunchCardItem *> *Data;

@end

@interface BATPunchCardItem : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,assign) NSInteger TemplateID;

@property (nonatomic,strong) NSString *TemplateName;

@property (nonatomic,assign) NSInteger AccountID;

@property (nonatomic,strong) NSString *ClockInTime;

@property (nonatomic,assign) NSInteger ClockFrequency;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,strong) NSString *UserName;

@end
