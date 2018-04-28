//
//  BATAudioView.m
//  HealthBAT_Pro
//
//  Created by four on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAudioView.h"

#import "BATTIMDataModel.h"

@interface BATAudioView ()
{
    __block AgoraRtcStats *lastStat_;
}
//时间icon
//@property (nonatomic,strong) UIImageView *timeImageView;
//时间label
@property (nonatomic,strong) UILabel *talkTimeLabel;
//计时器
@property (strong, nonatomic) NSTimer *durationTimer;
//持续时间
@property (nonatomic) NSUInteger duration;

//本地视频显示
@property (nonatomic,strong) UIView *localView;
//远程视频显示
@property (nonatomic,strong) UIView *remoteView;

@property (assign,nonatomic) BOOL isUpteTimeLabel;

@property (nonatomic,strong) UIAlertController *alert;

@end

@implementation BATAudioView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self pagesLayout];
        
        self.localView.hidden = YES;
        self.remoteView.hidden = YES;
        
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

/**
 *  初始化声网
 */
- (void)initAgoraKit
{
    //初始化，设置代理
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.AGDKeyChannel  delegate:self];
    [self.agoraKit  setVideoProfile:41 swapWidthAndHeight:YES];
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

/**
 *  时间变更
 */
- (void)updateTalkTimeLabel
{
    self.duration++;
    NSUInteger seconds = self.duration % 60;
    NSUInteger minutes = (self.duration - seconds) / 60;
    NSUInteger hours = self.duration / 3600;
    self.talkTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
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
    __weak typeof(self) weakSelf = self;
    // Update talk time
    if (weakSelf.duration == 0 && !weakSelf.durationTimer) {
        weakSelf.talkTimeLabel.text = @"00:00:00";
        weakSelf.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
    }
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
    
    self.isUpteTimeLabel = YES;
}

//#pragma mark - TIMMessageListener
//- (void)onNewMessage:(NSArray*) msgs {
//    
//    //接受消息，判断当前状态
//    for (TIMMessage *message in msgs) {
//        int cnt = [message elemCount];
//        
//        for (int i = 0; i < cnt; i++) {
//            TIMElem * elem = [message getElem:i];
//            
//            if ([elem isKindOfClass:[TIMCustomElem class]]) {
//                TIMCustomElem * customElem = (TIMCustomElem * )elem;
//                
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//                if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {
//                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
//                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                    DDLogError(@"%@",dic);
//                    
//                    [self handelWithMessage:dic];
//                }
//#pragma clang diagnostic pop
//                
//            }
//        }
//    }
//}
//
//#pragma mark - private
//
//- (void)handelWithMessage:(NSDictionary *)dic {
//    BATNewMessageModel *model = [BATNewMessageModel mj_objectWithKeyValues:dic];
//    
//    switch (model.ServiceType) {
//        case kDoctorServerWordImageType: {
//            
//            break;
//        }
//        case kDoctorServerAudioType: {
//            //音频
//            switch (model.State) {
//                case BATChatRoomState_Invalid: {
//                    
//                    break;
//                }
//                case BATChatRoomState_NoVisit: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Waiting: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Consulting: {
//                    [self.alert dismissViewControllerAnimated:YES completion:nil];
//                    break;
//                }
//                case BATChatRoomState_Consulted: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Calling: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Leaving: {
//                    //医生离开
//                    [self showCallingAlertWithTitle:@"结束服务" action:^{
//                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
//                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
////                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    break;
//                }
//            }
//            break;
//        }
//        case kDoctorServerVideoType: {
//            
//            switch (model.State) {
//                case BATChatRoomState_Invalid: {
//                    
//                    break;
//                }
//                case BATChatRoomState_NoVisit: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Waiting: {
//                    
//                    
//                    break;
//                }
//                case BATChatRoomState_Consulting: {
//                    [self.alert dismissViewControllerAnimated:YES completion:nil];
//                    
//                    break;
//                }
//                case BATChatRoomState_Consulted: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Calling: {
//                    
//                    break;
//                }
//                case BATChatRoomState_Leaving: {
//                    //医生离开
//                    [self showCallingAlertWithTitle:@"结束服务" action:^{
//                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
//                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
//                        
////                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    break;
//                }
//            }
//            
//            break;
//        }
//        case kDoctorServerHomeDoctor: {
//            
//            break;
//        }
//        case kDoctorServerRemote: {
//            
//            break;
//        }
//    }
//}
//
//
//- (void)showCallingAlertWithTitle:(NSString *)title action:(void (^)(void))action {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
//        
//    }];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:action];
//    [alert addAction:cancelAction];
//    [alert addAction:confirmAction];
////    [self presentViewController:alert animated:YES completion:nil];
//    
//    self.alert = alert;
//}
//
//#pragma mark - net
////改变状态
//- (void)changeRoomStateRequestWithState:(BATChatRoomState)state {
//    
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateRoomState" parameters:@{@"ChannelID":self.AGDKeyChannel,@"State":@(state)} type:kGET success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

#pragma  mark - pagesLayout
- (void)pagesLayout{
    
    WEAK_SELF(self);
    [self addSubview:self.remoteView];
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
//    [self addSubview:self.timeImageView];
//    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(self.mas_top).offset(10);
//        make.centerX.equalTo(self.mas_centerX).offset(-35);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(15);
//    }];
    
    [self addSubview:self.talkTimeLabel];
    [self.talkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.localView];
    [self.localView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.mas_offset(50);
        make.width.mas_offset(30);
    }];
}


//- (UIImageView *)timeImageView{
//    if (!_timeImageView) {
//        _timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_time_image"]];
//    }
//    return _timeImageView;
//}

- (UILabel *)talkTimeLabel{
    if (!_talkTimeLabel) {
        _talkTimeLabel = [[UILabel alloc]init];
        _talkTimeLabel.font = [UIFont systemFontOfSize:15];
        _talkTimeLabel.textAlignment = NSTextAlignmentCenter;
        _talkTimeLabel.textColor = [UIColor whiteColor];
        _talkTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _talkTimeLabel;
}

- (UIView *)localView{
    if (!_localView) {
        _localView = [[UIView alloc]init];
        _localView.backgroundColor = [UIColor blackColor];
    }
    return  _localView;
}


- (UIView *)remoteView{
    if (!_remoteView) {
        _remoteView = [[UIView alloc]init];
        _remoteView.backgroundColor = [UIColor lightGrayColor];
    }
    return  _remoteView;
}

@end
