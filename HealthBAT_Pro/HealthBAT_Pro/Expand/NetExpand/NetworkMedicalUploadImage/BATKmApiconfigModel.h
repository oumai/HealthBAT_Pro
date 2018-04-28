//
//  BATKmApiconfigModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiConfigModel;
@interface BATKmApiconfigModel : NSObject

@property (nonatomic, strong) ApiConfigModel *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface ApiConfigModel : NSObject

@property (nonatomic,copy) NSString *apptoken;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *userid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,copy) NSString *apiurl;

@property (nonatomic,copy) NSString *imgupload;

@end
