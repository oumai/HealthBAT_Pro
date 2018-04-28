//
//  BATVideoView.m
//  HealthBAT_Pro
//
//  Created by four on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATVideoView.h"

#import "BATTIMDataModel.h"

@interface BATVideoView ()
{
    __block AgoraRtcStats *lastStat_;
}

////本地视频显示
//@property (nonatomic,strong) UIView *localView;
////远程视频显示
//@property (nonatomic,strong) UIView *remoteView;

//@property (nonatomic,strong) UIView *bgView;

@end

@implementation BATVideoView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self pagesLayout];
        
    }
    return self;
}

#pragma mark - private
- (void)joinWithKey:(NSString *)key andWithChannel:(NSString *)channel{
    
    [self initAgoraKit];
    
//    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
//    BATLoginModel * login = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    
//    NSString *idconfig = login.Data.IMConfig.identifier;
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"];
    BATTIMDataModel * TIMData = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSString *idconfig = TIMData.Data.identifier;
    NSInteger idconfigNums = [idconfig integerValue];
    
    WEAK_SELF(self);
    [self.agoraKit joinChannelByKey:key channelName:channel info:nil uid:idconfigNums  joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        STRONG_SELF(self);
        [self setUpVideo:uid];
        [self.agoraKit setEnableSpeakerphone:YES];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

- (void)moveView:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    if (pan.view.center.x - self.localView.frame.size.width/2.0 < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.localView.frame = CGRectMake(0, pan.view.center.y - self.localView.frame.size.height/2.0, self.localView.frame.size.width, self.localView.frame.size.height);
        }];
    }
    
    if (pan.view.center.x + self.localView.frame.size.width/2.0 > SCREEN_WIDTH) {
        [UIView animateWithDuration:0.25 animations:^{
            self.localView.frame = CGRectMake(SCREEN_WIDTH - self.localView.frame.size.width, pan.view.center.y - self.localView.frame.size.height/2.0, self.localView.frame.size.width, self.localView.frame.size.height);
        }];
    }
    
    if (pan.view.center.y + self.localView.frame.size.height/2.0 > SCREEN_HEIGHT - 44) {
        [UIView animateWithDuration:0.25 animations:^{
            self.localView.frame = CGRectMake(pan.view.center.x - self.localView.frame.size.width/2.0, SCREEN_HEIGHT - self.localView.frame.size.height, self.localView.frame.size.width, self.localView.frame.size.height);
        }];
    }
    
    if (pan.view.center.y - self.localView.frame.size.height/2.0 < 64) {
        [UIView animateWithDuration:0.25 animations:^{
            self.localView.frame = CGRectMake(pan.view.center.x - self.localView.frame.size.width/2.0, 20, self.localView.frame.size.width, self.localView.frame.size.height);
        }];
    }
}


/**
 *  初始化声网
 */
- (void)initAgoraKit
{
    //初始化，设置代理
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.AGDKeyChannel  delegate:self];
    [self.agoraKit  setVideoProfile:41];
}

/**
 *  创建本地视频
 */
- (void)setUpVideo:(NSUInteger)uid
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = self.localView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
}

/**
 *  创建远程视频
 */
- (void)setUpRemoteVideo:(NSNumber *)uid{
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid.unsignedIntegerValue;
    videoCanvas.view = self.remoteView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
}


/**
 *  加入房间
 */
- (void)joinChannel
{
//    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
//    BATLoginModel * login = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    
//    NSString *idconfig = login.Data.IMConfig.identifier;
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"];
    BATTIMDataModel * TIMData = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSString *idconfig = TIMData.Data.identifier;
    NSInteger idconfigNums = [idconfig integerValue];
    
    WEAK_SELF(self);
    [self.agoraKit joinChannelByKey:self.AGDKeyVendorKey channelName:self.AGDKeyChannel info:nil uid:idconfigNums  joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        STRONG_SELF(self);
        [self setUpVideo:uid];
        [self.agoraKit setEnableSpeakerphone:YES];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
    
}

#pragma mark - AgoraRtcEngineKitDelegate
/**
 *  本地首帧视频显示回调
 *
 *  @param engine  声网类
 *  @param size    视频流尺寸(宽度和高度)
 *  @param elapsed 加入频道开始到该回调触发的延迟(毫秒)
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    DDLogDebug(@"local video display");
}

/**
 *  用户加入房间回调
 *
 *  @param engine  声网类
 *  @param uid     用户 ID
 *  @param elapsed 加入频道开始到该回调触发的延迟(毫秒)
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    DDLogDebug(@"self: %@", weakSelf);
    DDLogDebug(@"engine: %@", engine);
    
    DDLogDebug(@"======进入房间Uid%lu=======",(unsigned long)uid);
}

/**
 *  用户离线回调
 *
 *  @param engine 声网类
 *  @param uid    用户 ID
 *  @param reason 离线原因{  AgoraRtc_UserOffline_Quit：主动放弃
 *                          AgoraRtc_UserOffline_Dropped：超时掉线}
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    
}

/**
 *  用户停止/重新发送视频回调
 *
 *  @param engine 声网类
 *  @param muted  暂停、继续发送其视频流
 *  @param uid    用户 ID
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    DDLogDebug(@"user %@ mute video: %@", @(uid), muted ? @"YES" : @"NO");
}

/**
 *  网络丢失回调
 *
 *  @param engine 声网类
 */
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine
{
    
}

/**
 *  Rtc Engine 统计数据回调
 *
 *  @param engine 声网类
 *  @param stats
 duration：通话时长,累计值
 txBytes：发送字节数,累计值
 rxBytes：接收字节数,累计值
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats
{
    
}

/**
 *  发生错误回调
 *
 *  @param engine    声网类
 *  @param errorCode 错误代码
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    __weak typeof(self) weakSelf = self;
    if (errorCode == AgoraRtc_Error_InvalidChannelKey) {
        [weakSelf.agoraKit leaveChannel:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
    }
    DDLogDebug(@"%ld",(long)errorCode);
}

/**
 *  提示已收到第一帧远程视频流并解码
 *
 *  @param engine  声网类
 *  @param uid     用户 ID
 *  @param size    视频流尺寸
 *  @param elapsed 加入频道开始到该回调触发的延迟
 */
-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    
    DDLogDebug(@"======收到远程视频流Uid%lu=======",(unsigned long)uid);
    
    DDLogDebug(@"=======已收到第一帧远程视频流并解码========");
    [self setUpRemoteVideo:@(uid)];
}

/**
 *  提示第一帧远端视频画面已经显示在屏幕上
 *
 *  @param engine  声网类
 *  @param uid     用户 ID
 *  @param size    视频流尺寸
 *  @param elapsed 加入频道开始到该回调触发的延迟
 */
-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    DDLogDebug(@"=======提示第一帧远端视频画面已经显示在屏幕上========");
}



#pragma  mark - pagesLayout
- (void)pagesLayout{
    
    WEAK_SELF(self);
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self addSubview:self.remoteView];
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self addSubview:self.localView];
    [self.localView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(165);
        make.width.mas_offset(130);
    }];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    return _bgView;
}

- (UIView *)localView{
    if (!_localView) {
        _localView = [[UIView alloc]init];
        _localView.backgroundColor = [UIColor blackColor];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveView:)];
//        [_localView addGestureRecognizer:pan];
    }
    return  _localView;
}


- (UIView *)remoteView{
    if (!_remoteView) {
        _remoteView = [[UIView alloc]init];
        _remoteView.backgroundColor = [UIColor grayColor];
    }
    return  _remoteView;
}

@end

