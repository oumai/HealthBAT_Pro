//
//  NewsModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATNewsData;

@interface BATNewsModel : NSObject

@property (nonatomic, assign) NSInteger   PagesCount;

@property (nonatomic, assign) NSInteger   ResultCode;

@property (nonatomic, assign) NSInteger   RecordsCount;

@property (nonatomic, copy  ) NSString    *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATNewsData *> *Data;

@end


@interface BATNewsData : NSObject

@property (nonatomic, copy  ) NSString    *LastModifiedTime;

@property (nonatomic, copy  ) NSString    *LableName;

@property (nonatomic, copy  ) NSString    *MainImage;

@property (nonatomic, assign) NSInteger   ID;

@property (nonatomic, copy  ) NSString    *Body;

@property (nonatomic, assign) NSInteger   IsCollectLink;

@property (nonatomic, assign) NSInteger   ReadingQuantity;

@property (nonatomic, copy  ) NSString    *NewLableList;

@property (nonatomic, copy  ) NSString    *Title;

@property (nonatomic, copy  ) NSString    *NewsCategory;

@property (nonatomic, assign) NSInteger   Category;

@property (nonatomic, copy  ) NSString    *LableCode;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *CategoryId;

@end



