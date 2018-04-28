//
//  BATAgoraManager.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

typedef void(^ListenNetworkQuality)(AgoraRtcQuality quality);

@interface BATAgoraManager : NSObject

@property (nonatomic,strong) AgoraRtcEngineKit *agoraRtcEngineKit;

/**
 监听网络质量
 */
@property (nonatomic,strong) ListenNetworkQuality listenNetworkQuality;

+ (BATAgoraManager *)shared;

/**
 注册SDK
 */
- (void)registerAgora;

/**
 是否开启音频

 @param flag yes or no
 */
- (void)openAudio:(BOOL)flag;

/**
 是否开启视频

 @param flag yes or no
 */
- (void)openVideo:(BOOL)flag;

/**
 设置本地视频显示

 @param localView 本地视频view
 */
- (void)setupLocalVideo:(UIView *)localView;

/**
 设置远端视频显示

 @param remoteView 远端视频显示
 */
- (void)setupRemoteVideo:(UIView *)remoteView;

/**
 开启视频预览
 */
- (void)startPreview;

/**
 关闭视频预览
 */
- (void)stopPreview;

/**
 切换摄像头
 */
- (void)switchCamera;

/**
 加入频道

 @param key 频道key 当用户使用静态Key也即只使用App ID时, 该参数是可选的，传NULL即可，当用户使用Channel Key时，Agora为应用程序开发者额外签发一个App Certificate，开发者结合Agora提供的算法生成此Channel Key，用于服务器端用户验证。
 @param channelName 频道name
 @param info 附加信息 一般可设置为空字符串，或频道相关信息。该信息不会传递给频道内的其他用户。
 @param uid 用户id 如果不指定（即设为0），SDK 会自动分配一个
 @param joinChannelSuccessBlock 回调
 */
- (void)joinCahannel:(NSString *)key channelName:(NSString *)channelName info:(NSString *)info uid:(NSUInteger)uid joinSuccess:(void(^)(NSString* channel, NSUInteger uid, NSInteger elapsed))joinChannelSuccessBlock;

/**
 离开频道

 @param leaveChannelBlock 回调
 */
- (void)leaveChannel:(void(^)(AgoraRtcStats* stat))leaveChannelBlock;

@end
