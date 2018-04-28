//
//  BATRongCloudManager.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface BATRongCloudManager : NSObject <RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>
singletonInterface(BATRongCloudManager)

@property (nonatomic,strong) NSMutableDictionary *userInfoDic;

@property (nonatomic,copy) void(^continueIMBlock)(NSString *orderNo);
@property (nonatomic,copy) void(^endIMBlock)(NSString *orderNo);

/**
 融云登录

 @param rongCloudToken 融云token
 @param success 成功
 @param error 错误
 @param tokenIncorrect token错误
 */
- (void)bat_loginRongCloudWithToken:(NSString *)rongCloudToken
                            success:(void(^)(NSString *userId))success
                              error:(void(^)(RCConnectErrorCode status))error
                     tokenIncorrect:(void(^)(void))tokenIncorrect;


/**
 登出融云
 */
- (void)bat_loginOutRongCloud;


/**
 获取融云的连接状态

 @return 连接状态，YES为连接中，NO为未连接
 */
- (BOOL)bat_getRongCloudStatus;


/**
 融云注册推送

 @param deviceToken deviceToken
 */
- (void)bat_rongCloudRegistDeviceToken:(NSData *)deviceToken;


/**
 融云保存用户信息

 @param userId 融云userID
 @param name 用户昵称
 @param portraitUri 用户头像
 */
- (void)bat_saveRongCloudUserInfoWithUserId:(NSString *)userId
                                       name:(NSString *)name
                                portraitUri:(NSString *)portraitUri;


/**
 获取当前登录的融云用户信息

 @return 获取当前登录的融云用户信息
 */
- (RCUserInfo *)bat_getRongCloudUserInfo;

/**
 发送融云消息

 @param type 发送消息的会话类型
 @param targetId 发送消息的目标会话ID
 @param content 消息的内容
 @param pushContent 接收方离线时需要显示的远程推送内容
 @param pushData 接收方离线时需要在远程推送中携带的非显示数据
 @param success 消息发送成功的回调 [messageId:消息的ID]
 @param error 消息发送失败的回调 [nErrorCode:发送失败的错误码, messageId:消息的ID]
 
 */
- (void)bat_sendRongCloudMessageWithType:(RCConversationType)type
                                targetId:(NSString *)targetId
                                 content:(RCMessageContent *)content
                             pushContent:(NSString *)pushContent
                                pushData:(NSString *)pushData
                                 success:(void(^)(long messageId))success
                                   error:(void(^)(RCErrorCode nErrorCode, long messageId))error;


/**
 讲融云的用户信息存入到本地

 @return 是否写入本地成功
 */
- (BOOL)bat_rongCloudUserWriteToFile;


/**
 获取bat用户信息，同步更改融云用户信息

 @param accountID accountID
 */
- (void)bat_userInfoRequestWithAccountID:(NSString *)accountID;
@end
