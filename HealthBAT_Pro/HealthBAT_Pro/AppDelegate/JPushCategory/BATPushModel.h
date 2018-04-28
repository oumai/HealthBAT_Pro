//
//  BATPushModel.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class PushAps,RongCloudData;

@interface BATPushModel : NSObject

//融云参数
@property (nonatomic,strong) RongCloudData *rc;
@property (nonatomic, copy) NSString *appData;

//极光参数
@property (nonatomic, assign) BATJPushMsgType JPushMsgType;
@property (nonatomic, copy) NSString *_j_msgid;

//通用
@property (nonatomic, strong) PushAps *aps;

@end

@interface PushAps : NSObject

@property (nonatomic, copy) NSString *alert;
@property (nonatomic, assign) NSInteger badge;
@property (nonatomic, copy) NSString *sound;

@end

//{"cType":"PR","fId":"xxx","oName":"xxx","tId":"xxxx"}
@interface RongCloudData : NSObject

/**
 会话类型。PR 指单聊、 DS 指讨论组、 GRP 指群组、 CS 指客服、SYS 指系统会话、 MC 指应用内公众服务、 MP 指跨应用公众服务。
 */
@property (nonatomic,copy) NSString *cType;

/**
 消息发送者的用户 ID。
 */
@property (nonatomic,copy) NSString *fId;

/**
 消息类型，参考融云消息类型表.消息标志；可自定义消息类型。
 */
@property (nonatomic,copy) NSString *oName;

/**
 Target ID。(BAT代表roomID)
 */
@property (nonatomic,copy) NSString *tId;

@end
