//
//  BATRoomInfoModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/10/102016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class RoomInfoData;
@interface BATRoomInfoModel : NSObject

@property (nonatomic, strong) RoomInfoData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end
@interface RoomInfoData : NSObject

@property (nonatomic, copy) NSString *Secret;

@property (nonatomic, assign) NSInteger TotalTime;

@property (nonatomic, copy) NSString *BeginTime;

@property (nonatomic, assign) NSInteger RoomState;

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, copy) NSString *ConversationRoomID;

@property (nonatomic, assign) NSInteger ChannelID;

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, copy) NSString *ServiceID;

@end

