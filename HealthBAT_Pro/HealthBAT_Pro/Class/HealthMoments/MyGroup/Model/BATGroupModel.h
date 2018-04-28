//
//  GroupModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATGroupData;

@interface BATGroupModel : NSObject

@property (nonatomic, assign) NSInteger    PagesCount;

@property (nonatomic, assign) NSInteger    ResultCode;

@property (nonatomic, assign) NSInteger    RecordsCount;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATGroupData *> *Data;

@end


@interface BATGroupData : NSObject

@property (nonatomic, copy  ) NSString     *GroupIcon;

@property (nonatomic, copy  ) NSString     *Description;

@property (nonatomic, assign) NSInteger    MemberCount;

@property (nonatomic, assign) BOOL         IsJoined;

@property (nonatomic, assign) NSInteger    GroupTotal;

@property (nonatomic, copy  ) NSString     *Members;

@property (nonatomic, assign) NSInteger    ID;

@property (nonatomic, copy  ) NSString     *GroupName;

@end

