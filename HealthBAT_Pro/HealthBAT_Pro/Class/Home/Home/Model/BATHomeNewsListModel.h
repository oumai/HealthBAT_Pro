//
//  BATHomeNewsListModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/202016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HomeNewsListResultdata,HomeNewsContent;
@interface BATHomeNewsListModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) HomeNewsListResultdata *resultData;

@end
@interface HomeNewsListResultdata : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<HomeNewsContent *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

@interface HomeNewsContent : NSObject

@property (nonatomic, copy) NSString *mainImage;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *readingQuantity;

@property (nonatomic, copy) NSString *sourceName;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *categoryId;

@end

