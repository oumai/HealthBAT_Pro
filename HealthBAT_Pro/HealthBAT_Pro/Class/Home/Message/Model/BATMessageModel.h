//
//  BATMessageModel.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATMessagesData;
@interface BATMessageModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATMessagesData *> *Data;


@end

@interface BATMessagesData : NSObject

@property (nonatomic, copy  ) NSString          *CreatedTime;

@property (nonatomic, assign) NSInteger         ID;

@property (nonatomic, assign) NSInteger         MsgCount;

@property (nonatomic, assign) NSInteger         MsgType;

@property (nonatomic, assign) NSInteger         OrderState;

@property (nonatomic, copy  ) NSString          *MsgTypeName;

@property (nonatomic, copy  ) NSString          *ObjAccountID;

@property (nonatomic, copy  ) NSString          *ObjPicUrl;

@property (nonatomic, copy  ) NSString          *Title;

@property (nonatomic, copy  ) NSString          *ExtrasContent;

@end

