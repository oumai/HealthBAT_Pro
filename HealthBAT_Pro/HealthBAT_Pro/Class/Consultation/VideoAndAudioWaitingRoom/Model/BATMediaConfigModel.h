//
//  BATMedioConfigModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/10/92016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class MediaConfigData;
@interface BATMediaConfigModel : NSObject

@property (nonatomic, strong) MediaConfigData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface MediaConfigData : NSObject

@property (nonatomic, copy) NSString *Secret;

@property (nonatomic, assign) BOOL Video;

@property (nonatomic, assign) BOOL Screen;

@property (nonatomic, assign) BOOL Audio;

@property (nonatomic, copy) NSString *AppID;

@property (nonatomic, copy) NSString *MediaChannelKey;

@property (nonatomic, copy) NSString *RecordingKey;

@end

