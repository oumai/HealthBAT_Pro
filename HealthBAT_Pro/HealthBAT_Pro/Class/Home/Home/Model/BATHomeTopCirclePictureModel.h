//
//  BATHomeTopCirclePictureModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HomeTopPictureData;
@interface BATHomeTopCirclePictureModel : NSObject

@property (nonatomic, strong) NSArray<HomeTopPictureData *> *Data;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface HomeTopPictureData : NSObject

@property (nonatomic, copy) NSString *ID;

/**
 跳转项目所需ID
 */
@property (nonatomic, copy) NSString *RelationID;
@property (nonatomic, assign) BATHomeADType CarouselType;
@property (nonatomic, copy) NSString *CarouselTitle;
@property (nonatomic, copy) NSString *LinkAddress;
@property (nonatomic, copy) NSString *CarouselUrl;
@property (nonatomic, copy) NSString *CarouseRemark;
@property (nonatomic, copy) NSString *CreatedTime;
@property (nonatomic, copy) NSString *CreatedBy;
@property (nonatomic, copy) NSString *LastModifiedTime;
@property (nonatomic, copy) NSString *LastModifiedBy;
@property (nonatomic, assign) BOOL IsDeleted;

@end

