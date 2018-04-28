//
//  BATNewMessageModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/10/92016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BATNewMessageModel : NSObject

@property (nonatomic,assign) NSInteger ChannelID;
@property (nonatomic,assign) BATChatRoomState State;
@property (nonatomic,copy) NSString *ServiceID;
@property (nonatomic,assign) DoctorServerType ServiceType;

@end
