//
//  BATAgoraManager.m
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "BATAgoraManager.h"

@interface BATAgoraManager () <AgoraRtcEngineDelegate>

@property (nonatomic,strong) UIView *remoteView;

@end

@implementation BATAgoraManager

+ (BATAgoraManager *)shared
{
    static BATAgoraManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATAgoraManager alloc] init];
    });
    return instance;
}

- (void)registerAgora
{
    self.agoraRtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppId delegate:self];
    [self.agoraRtcEngineKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
}

- (void)openAudio:(BOOL)flag
{
    if (flag) {
        [self.agoraRtcEngineKit enableAudio];
    } else {
        [self.agoraRtcEngineKit disableAudio];
    }
}

- (void)openVideo:(BOOL)flag
{
    if (flag) {
        [self.agoraRtcEngineKit enableVideo];
        [self.agoraRtcEngineKit setVideoProfile:AgoraRtc_VideoProfile_360P swapWidthAndHeight:false];
    } else {
        [self.agoraRtcEngineKit disableVideo];
    }
}

- (void)setupLocalVideo:(UIView *)localView
{
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    
    videoCanvas.view = localView;
    videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraRtcEngineKit setupLocalVideo:videoCanvas];
}

- (void)setupRemoteVideo:(UIView *)remoteView
{
    self.remoteView = remoteView;
}

- (void)startPreview
{
    [self.agoraRtcEngineKit startPreview];
}

- (void)stopPreview
{
    [self.agoraRtcEngineKit stopPreview];
}

- (void)switchCamera
{
    [self.agoraRtcEngineKit switchCamera];
}

- (void)joinCahannel:(NSString *)key channelName:(NSString *)channelName info:(NSString *)info uid:(NSUInteger)uid joinSuccess:(void (^)(NSString *, NSUInteger, NSInteger))joinChannelSuccessBlock
{
    [self.agoraRtcEngineKit joinChannelByKey:key channelName:channelName info:info uid:uid joinSuccess:joinChannelSuccessBlock];
}

- (void)leaveChannel:(void (^)(AgoraRtcStats *))leaveChannelBlock
{
    [self.agoraRtcEngineKit leaveChannel:leaveChannelBlock];
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurWarning:(AgoraRtcWarningCode)warningCode
{
    //发生警告回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    //发生错误回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    //加入频道成功回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    //重新加入频道回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    //本地首帧视频显示回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    //远端首帧视频接收解码回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    //远端首帧视频显示回调
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    
    videoCanvas.view = self.remoteView;
    videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraRtcEngineKit setupLocalVideo:videoCanvas];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    //用户加入回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    //用户离线回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    //用户停止/重新发送视频回调
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine lastmileQuality:(AgoraRtcQuality)quality
{
    //网络质量回调
    
    if (self.listenNetworkQuality) {
        self.listenNetworkQuality(quality);
    }
}

@end
