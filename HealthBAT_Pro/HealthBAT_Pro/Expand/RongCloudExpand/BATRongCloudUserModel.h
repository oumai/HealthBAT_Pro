//
//  BATRongCloudUserModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/192017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATRongCloudUserData;
@interface BATRongCloudUserModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATRongCloudUserData *Data;

@end

@interface BATRongCloudUserData : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *AccountID;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *PhotoPath;

@end
