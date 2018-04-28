//
//  BATAgoraSignalingManager.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "agorasdk.h"

@protocol BATAgoraSignalingManagerDelegate <NSObject>

@optional

/**
 收到呼叫邀请
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteReceived:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 对方已收到呼叫
 
 @param channel chanelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteReceivedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 对方已接受呼叫
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteAcceptedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 对方已拒绝呼叫
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteRefusedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 对方已结束呼叫
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteEndByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 自己结束呼叫
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param extra 扩展字段
 */
- (void)inviteEndByMyself:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra;

/**
 呼叫失败
 
 @param channel channelID
 @param name 对方的ID
 @param uid 声网生成的ID
 @param ecode 错误码
 @param extra 扩展字段
 */
- (void)inviteFailed:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid ecode:(AgoraEcode)ecode extra:(NSString *)extra;

@end


@interface BATAgoraSignalingManager : NSObject

@property (nonatomic,strong) AgoraAPI *agoraSignaling;

/**
 当前所在频道
 */
@property (nonatomic,strong) NSString *channelID;

@property (nonatomic,weak) id<BATAgoraSignalingManagerDelegate> delegate;


+ (BATAgoraSignalingManager *)shared;

/**
 注册信令
 */
- (void)registerAgoraSignaling;

/**
 登录
 
 @param appId appID
 @param token 由 App ID 和 App Certificate 生成的 Signaling Key
 @param deviceID 暂时无用，设置为空
 @param complete 回调
 */
- (void)login:(NSString *)account token:(NSString *)token deviceID:(NSString *)deviceID complete:(void (^)(BOOL success))complete;

/**
 是否在线
 
 @return yes or no
 */
- (BOOL)isOnline;

/**
 登出
 
 @param complete 回调
 */
- (void)logout:(void (^)(BOOL success))complete;

/**
 加入频道
 
 @param channelID 频道id
 @param complete 回调
 */
- (void)channelJoin:(NSString *)channelID complete:(void (^)(BOOL success))complete;

/**
 离开频道
 
 @param channelID 频道id
 */
- (void)channelLeave:(NSString *)channelID;

/**
 发起呼叫
 
 @param channelID 频道id
 @param account 用户名
 */
- (void)channelInviteUser2:(NSString *)channelID account:(NSString *)account extra:(NSString *)extra;

/**
 接受呼叫
 
 @param channelID 频道id
 @param account 用户名
 */
- (void)channelInviteAccept:(NSString *)channelID account:(NSString *)account;

/**
 拒绝呼叫
 
 @param channelID 频道id
 @param account 用户名
 @param extra 扩展字段
 */
- (void)channelInviteRefuse:(NSString *)channelID account:(NSString *)account extra:(NSString *)extra;

/**
 结束呼叫
 
 @param channelID 频道id
 @param account 用户名
 */
- (void)channelInviteEnd:(NSString*)channelID account:(NSString*)account;

@end
