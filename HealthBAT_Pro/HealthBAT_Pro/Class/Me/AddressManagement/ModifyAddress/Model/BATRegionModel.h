//
//  BATRegionModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATRegionItem;
@interface BATRegionModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATRegionItem *> *Data;

@end

@interface BATRegionItem : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger Code;

@property (nonatomic, assign) NSInteger ParentCode;

@property (nonatomic, strong) NSString *Name;

@property (nonatomic, assign) NSInteger Level;

@property (nonatomic, strong) NSString *Latitude;

@property (nonatomic, strong) NSString *Longitude;

@end
