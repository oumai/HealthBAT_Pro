//
//  BATtest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class SearchResultdata,SearchContent;
@interface BATSearchResultModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSMutableArray<SearchResultdata *> *resultData;

@end
@interface SearchResultdata : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<SearchContent *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

@interface SearchContent : NSObject

@property (nonatomic, copy) NSString *resultDesc;

@property (nonatomic, copy) NSString *resultTitle;

@property (nonatomic, copy) NSString *symptoms;

@property (nonatomic, copy) NSString *resultType;

@property (nonatomic, copy) NSString *resultId;

@property (nonatomic, copy) NSString *mainImage;

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *pictureUrl;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *hospitalAlias;

@property (nonatomic, copy) NSString *hospitalLevel;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger dataType;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *addressArea;

@property (nonatomic, copy) NSString *telPhone;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *manufactorName;

@property (nonatomic, copy) NSString *drugSource;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *categoryId;

@end

