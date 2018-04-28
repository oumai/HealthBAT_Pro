//
//  BATAgoraSignalingManager.m
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "BATAgoraSignalingManager.h"

@implementation BATAgoraSignalingManager

+ (BATAgoraSignalingManager *)shared
{
    static BATAgoraSignalingManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATAgoraSignalingManager alloc] init];
    });
    return instance;
}

- (void)registerAgoraSignaling
{
    
    self.agoraSignaling = [AgoraAPI getInstanceWithoutMedia:AgoraAppId];
    
    
    WEAK_SELF(self);
    self.agoraSignaling.onChannelUserJoined = ^(NSString *account, uint32_t uid) {
        //其他用户加入同一频道
        DDLogDebug(@"其他用户加入同一频道 account %@",account);
    };
    
    self.agoraSignaling.onChannelUserLeaved = ^(NSString *account, uint32_t uid) {
        //用户离开频道
        DDLogDebug(@"用户离开频道 account %@",account);
    };
    
    self.agoraSignaling.onInviteReceived = ^(NSString* channel, NSString *name, uint32_t uid, NSString *extra){
        //收到呼叫邀请
        DDLogDebug(@"收到呼叫邀请 channel %@,account %@",channel,name);
        STRONG_SELF(self);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteReceived:name:uid:extra:)]) {
            [self.delegate inviteReceived:channel name:name uid:uid extra:extra];
        }
    };
    
    self.agoraSignaling.onInviteReceivedByPeer = ^(NSString* channel, NSString *name, uint32_t uid){
        //对方已收到呼叫
        DDLogDebug(@"对方已收到呼叫 channel %@,account %@",channel,name);
        STRONG_SELF(self);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteReceivedByPeer:name:uid:extra:)]) {
            [self.delegate inviteReceivedByPeer:channel name:name uid:uid extra:nil];
        }
    };
    
    self.agoraSignaling.onInviteAcceptedByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        //对方已接受呼叫
        DDLogDebug(@"对方已接受呼叫 channel %@,account %@",channelID,account);
        STRONG_SELF(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteAcceptedByPeer:name:uid:extra:)]) {
            [self.delegate inviteAcceptedByPeer:channelID name:account uid:uid extra:extra];
        }
    };
    
    self.agoraSignaling.onInviteRefusedByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        //对方已拒绝呼叫
        DDLogDebug(@"对方已拒绝呼叫 channel %@,account %@",channelID,account);
        STRONG_SELF(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteRefusedByPeer:name:uid:extra:)]) {
            [self.delegate inviteRefusedByPeer:channelID name:account uid:uid extra:extra];
        }
    };
    
    self.agoraSignaling.onInviteEndByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        //对方已结束呼叫
        DDLogDebug(@"对方已结束呼叫 channel %@,account %@",channelID,account);
        STRONG_SELF(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteEndByPeer:name:uid:extra:)]) {
            [self.delegate inviteEndByPeer:channelID name:account uid:uid extra:extra];
        }
    };
    
    self.agoraSignaling.onInviteEndByMyself = ^(NSString* channel, NSString *name, uint32_t uid){
        //自己结束呼叫
        DDLogDebug(@"自己结束呼叫 channel %@,account %@",channel,name);
        STRONG_SELF(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteEndByMyself:name:uid:extra:)]) {
            [self.delegate inviteEndByMyself:channel name:name uid:uid extra:nil];
        }
    };
    
    self.agoraSignaling.onInviteFailed = ^(NSString *channelID, NSString *account, uint32_t uid, AgoraEcode ecode, NSString *extra) {
        //呼叫失败
        DDLogDebug(@"呼叫失败 channel %@,account %@",channelID,account);
        STRONG_SELF(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFailed:name:uid:ecode:extra:)]) {
            [self.delegate inviteFailed:channelID name:account uid:uid ecode:ecode extra:extra];
        }
    };
    
}

- (void)login:(NSString *)account token:(NSString *)token deviceID:(NSString *)deviceID complete:(void (^)(BOOL))complete
{
    
    [self.agoraSignaling login:AgoraAppId account:account token:token uid:0 deviceID:deviceID];
    
    self.agoraSignaling.onLoginSuccess = ^(uint32_t uid, int fd) {
        //登录成功
        
        DDLogDebug(@"登录声网信令成功");
        
        if (complete) {
            complete(YES);
        }
    };
    
    self.agoraSignaling.onLoginFailed = ^(AgoraEcode ecode) {
        //登录失败
        
        DDLogDebug(@"登录声网信令失败");
        
        if (complete) {
            complete(NO);
        }
    };
    
    
}

- (BOOL)isOnline
{
    return [self.agoraSignaling isOnline];
}

- (void)logout:(void (^)(BOOL))complete
{
    [self.agoraSignaling logout];
    
    self.agoraSignaling.onLoginFailed = ^(AgoraEcode ecode) {
        if (ecode == AgoraEcode_LOGOUT_E_USER){
            if (complete) {
                complete(YES);
            }
        } else {
            if (complete) {
                complete(NO);
            }
        }
    };
}

- (void)channelJoin:(NSString *)channelID complete:(void (^)(BOOL))complete
{
    [self.agoraSignaling channelJoin:channelID];
    
    WEAK_SELF(self);
    self.agoraSignaling.onChannelJoined = ^(NSString *channelID) {
        //用户加入频道成功
        STRONG_SELF(self);
        
        self.channelID = channelID;
        if (complete) {
            complete(YES);
        }
    };
    
    self.agoraSignaling.onChannelJoinFailed = ^(NSString *channelID, AgoraEcode ecode) {
        //用户加入频道失败
        
        STRONG_SELF(self);
        
        self.channelID = nil;
        
        if (complete) {
            complete(NO);
        }
    };
}

- (void)channelLeave:(NSString *)channelID
{
    [self.agoraSignaling channelLeave:channelID];
    
    self.channelID = nil;
}

- (void)channelInviteUser2:(NSString *)channelID account:(NSString *)account extra:(NSString *)extra
{
    [self.agoraSignaling channelInviteUser2:channelID account:account extra:extra];
}

- (void)channelInviteAccept:(NSString *)channelID account:(NSString *)account
{
    self.channelID = channelID;
    
    [self.agoraSignaling channelInviteAccept:channelID account:account uid:0];
}

- (void)channelInviteRefuse:(NSString *)channelID account:(NSString *)account extra:(NSString *)extra
{
    [self.agoraSignaling channelInviteRefuse:channelID account:account uid:0 extra:extra];
}

- (void)channelInviteEnd:(NSString *)channelID account:(NSString *)account
{
    [self.agoraSignaling channelInviteEnd:channelID account:account uid:0];
}

@end
