//
//  HotKeyModel.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HotKeyData;
@interface BATHotKeyModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<HotKeyData *> *Data;

@end
@interface HotKeyData : NSObject

@property (nonatomic, copy) NSString *Keyword;

@property (nonatomic, assign) BOOL isSelect;

@end

