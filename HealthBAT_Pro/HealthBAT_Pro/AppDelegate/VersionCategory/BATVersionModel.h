//
//  BATVersionModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VersionData,VersionMessage;
@interface BATVersionModel : NSObject

@property (nonatomic, strong) VersionData *Data;

@property (nonatomic, assign) NSInteger ResultCode;

@end

@interface VersionData : NSObject

@property (nonatomic, copy) NSString *UpAddress;

@property (nonatomic, assign) BOOL IsUpdate;

@property (nonatomic, strong) NSArray<VersionMessage *> *UpdateMessageList;

@end

@interface VersionMessage : NSObject

@property (nonatomic, copy) NSString *Keyword;

@end
