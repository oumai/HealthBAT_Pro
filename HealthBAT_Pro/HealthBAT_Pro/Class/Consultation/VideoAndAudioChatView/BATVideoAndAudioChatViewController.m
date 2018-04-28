//
//  BATVideoAndAudioChatViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATVideoAndAudioChatViewController.h"
#import "BATNewMessageModel.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "BATConsultationDoctorDetailModel.h"
#import "BATTIMDataModel.h"

@interface BATVideoAndAudioChatViewController ()<AgoraRtcEngineDelegate,TIMMessageListener>
{
    __block AgoraRtcStats *lastStat_;
}

//声网类
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

//视频了解界面背景
@property (nonatomic,strong) UIImageView *bgImageView;
//医生头像
@property (nonatomic,strong) UIImageView *doctorImageView;
//医生名字
@property (nonatomic,strong) UILabel *doctorNameLable;
//时间icon
@property (nonatomic,strong) UIImageView *timeImageView;
//时间label
@property (nonatomic,strong) UILabel *talkTimeLabel;
//计时器
@property (strong, nonatomic) NSTimer *durationTimer;
//持续时间
@property (nonatomic) NSUInteger duration;
//本地视频显示
@property (nonatomic,strong) UIView *localBGView;
@property (nonatomic,strong) UIImageView *localImageBGView;
@property (nonatomic,strong) UIView *localView;
//远程视频显示
@property (nonatomic,strong) UIView *remoteBGView;
@property (nonatomic,strong) UIView *remoteView;
//语音静音
@property (nonatomic,strong) UIButton *muteBtn;
//关闭视频摄像头
@property (nonatomic,strong) UIButton *closeCameraBtn;
//挂断按钮
@property (nonatomic,strong) UIButton *hangUpBtn;
//类型
//@property (assign, nonatomic) AGDChatType type;

@property (assign,nonatomic) BOOL isUpteTimeLabel;

@property (nonatomic,strong) UIAlertController *alert;


@end

@implementation BATVideoAndAudioChatViewController

- (void)dealloc {
    
    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagesLayout];
    
    [self doctorInfoRequest];

    //获取对话
    [[BATTIMManager sharedBATTIM] bat_currentConversationWithType:TIM_GROUP receiver:[NSString stringWithFormat:@"%@",self.AGDKeyChannel]];
    //添加消息监听
    [[BATTIMManager sharedBATTIM] bat_MessageListener:self];

    [self initAgoraKit];
    
    if(self.chatType == BATChatType_Audio){
        self.localBGView.hidden = YES;
        self.localImageBGView.hidden = YES;
        self.localView.hidden = YES;
        self.remoteView.hidden = YES;
    }else{
        self.localBGView.hidden = NO;
        self.localImageBGView.hidden = NO;
        self.localView.hidden = NO;
        self.remoteView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;

    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isUpteTimeLabel = NO;
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

//    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
//        
//    }];
    
    [self joinChannel];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }

    
//    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
//        
//    }];
}

#pragma mark -net
- (void)doctorInfoRequest {
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDoctorDetail" parameters:@{@"doctorId":self.doctorID} type:kGET success:^(id responseObject) {
        
        BATConsultationDoctorDetailModel *doctor = [BATConsultationDoctorDetailModel mj_objectWithKeyValues:responseObject];
        [self.doctorImageView sd_setImageWithURL:[NSURL URLWithString:doctor.Data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        self.doctorNameLable.text = doctor.Data.DoctorName;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
/**
 *  初始化声网
 */
- (void)initAgoraKit
{
//    static NSString *const theVendorKey = @"d319fe61f24440c0bc439ca93b4371a0";
    //初始化，设置代理
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.AGDKeyChannel  delegate:self];
    [self.agoraKit  setVideoProfile:41];
    
//    [self setUpVideo];
//    [self setUpVideo:0];
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


#pragma mark - action
/**
 *  关闭摄像头
 *
 *  @param button nil
 */
-(void)closeCameraBtnClick:(UIButton *)button{
    DDLogDebug(@"======摄像头被点击了======");
    button.selected = !button.selected;
    if(button.selected){
        self.localBGView.hidden = YES;
        self.localImageBGView.hidden = YES;
        self.localView.hidden = YES;
        self.remoteView.hidden = YES;
        [self.agoraKit muteLocalVideoStream:button.selected];
    }else{
        self.localBGView.hidden = NO;
        self.localImageBGView.hidden = NO;
        self.localView.hidden = NO;
        self.remoteView.hidden = NO;
        [self.agoraKit muteLocalVideoStream:button.selected];
    }
}

/**
 *  挂断
 *
 *  @param sender nil
 */
-(void)hungUp:(UIButton *)button{
    DDLogDebug(@"======结束通话======");

    [self changeRoomStateRequestWithState:BATChatRoomState_CutConnection];

    [self showCallingAlertWithTitle:@"离开" action:^{
        
        __weak typeof(self) weakSelf = self;
        [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
            // Myself leave status
            [weakSelf.durationTimer invalidate];
            [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [UIApplication sharedApplication].idleTimerDisabled = NO;
        }];
    }];
}


/**
 *  静音
 */
-(void)muteBtnClick:(UIButton *)button{
    DDLogDebug(@"======静音被点击了======");
    button.selected = !button.selected;
    if (self.chatType == BATChatType_Video) {
//        [self.agoraKit muteLocalVideoStream:button.selected];
        [self.agoraKit muteLocalAudioStream:button.selected];
    }else{
        [self.agoraKit muteLocalAudioStream:button.selected];
    }
}

/**
 *  时间变更
 */
- (void)updateTalkTimeLabel
{
    self.duration++;
    NSUInteger seconds = self.duration % 60;
    NSUInteger minutes = (self.duration - seconds) / 60;
    NSUInteger hours = self.duration / 360;
    self.talkTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
}

- (void)hiddenRemoteView{
    self.localBGView.hidden = YES;
    self.localImageBGView.hidden = YES;
    self.localView.hidden = YES;
    self.remoteView.hidden = YES;
}

- (void)showRemoteView{
    self.localBGView.hidden = NO;
    self.localImageBGView.hidden = NO;
    self.localView.hidden = NO;
    self.remoteView.hidden = NO;
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
    NSLog(@"local video display");
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
    NSLog(@"self: %@", weakSelf);
    NSLog(@"engine: %@", engine);
    
    DDLogDebug(@"======进入房间Uid%lu=======",(unsigned long)uid);
//    [self setUpRemoteVideo:@(uid)];
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
    
    //取消用户显示
    [self hiddenRemoteView];
    
    if(reason == AgoraRtc_UserOffline_Quit){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"用户%ld主动退出房间",(unsigned long)uid] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(reason == AgoraRtc_UserOffline_Dropped){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"用户%ld超时掉线退出房间",(unsigned long)uid] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
//    __weak typeof(self) weakSelf = self;
//    NSLog(@"user %@ mute video: %@", @(uid), muted ? @"YES" : @"NO");
}

/**
 *  网络丢失回调
 *
 *  @param engine 声网类
 */
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine
{
//    __weak typeof(self) weakSelf = self;
//    weakSelf.localView.hidden = YES;
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
    if (self.chatType == BATChatType_Audio) {
        __weak typeof(self) weakSelf = self;
        // Update talk time
        if (weakSelf.duration == 0 && !weakSelf.durationTimer) {
            weakSelf.talkTimeLabel.text = @"00:00:00";
            weakSelf.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
        }
    }else{
        if (self.isUpteTimeLabel == YES) {
            __weak typeof(self) weakSelf = self;
            // Update talk time
            if (weakSelf.duration == 0 && !weakSelf.durationTimer) {
                weakSelf.talkTimeLabel.text = @"00:00:00";
                weakSelf.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
            }
        }
    }
//    NSUInteger traffic = (stats.txBytes + stats.rxBytes - lastStat_.txBytes - lastStat_.rxBytes) / 1024;
//    NSUInteger speed = traffic / (stats.duration - lastStat_.duration);
//    NSString *trafficString = [NSString stringWithFormat:@"%@KB/s", @(speed)];
//    weakSelf.dataTrafficLabel.text = trafficString;
//    lastStat_ = stats;
}

/**
 *  发生错误回调
 *
 *  @param engine    声网类
 *  @param errorCode 错误代码
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
//    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
//        
//    }];
    __weak typeof(self) weakSelf = self;
//    [self.agoraKit renewChannelKey:self.AGDKeyVendorKey];
//    [self joinChannel];
    if (errorCode == AgoraRtc_Error_InvalidChannelKey) {
        [weakSelf.agoraKit leaveChannel:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
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
    
    NSLog(@"=======已收到第一帧远程视频流并解码========");
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
    NSLog(@"=======提示第一帧远端视频画面已经显示在屏幕上========");
    
    self.isUpteTimeLabel = YES;
//    if (self.chatType == AGDChatTypeAudio) {
//        [self hiddenRemoteView];
//    }else{
//        [self showRemoteView];
//    }
}

#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray*) msgs {

    //接受消息，判断当前状态
    for (TIMMessage *message in msgs) {
        int cnt = [message elemCount];

        for (int i = 0; i < cnt; i++) {
            TIMElem * elem = [message getElem:i];

            if ([elem isKindOfClass:[TIMCustomElem class]]) {
                TIMCustomElem * customElem = (TIMCustomElem * )elem;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {
                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    DDLogError(@"%@",dic);

                    [self handelWithMessage:dic];
                }
#pragma clang diagnostic pop
                
            }
        }
    }
}

#pragma mark - private

- (void)handelWithMessage:(NSDictionary *)dic {
    BATNewMessageModel *model = [BATNewMessageModel mj_objectWithKeyValues:dic];

    switch (model.ServiceType) {
        case kDoctorServerWordImageType: {

            break;
        }
        case kDoctorServerAudioType: {
            //音频
            switch (model.State) {
                case BATChatRoomState_Invalid: {

                    break;
                }
                case BATChatRoomState_NoVisit: {

                    break;
                }
                case BATChatRoomState_Waiting: {

                    break;
                }
                case BATChatRoomState_Consulting: {
                    [self.alert dismissViewControllerAnimated:YES completion:nil];
                    break;
                }
                case BATChatRoomState_Consulted: {

                    break;
                }
                case BATChatRoomState_Calling: {

                    break;
                }
                case BATChatRoomState_Leaving: {
                    //医生离开
                    [self showCallingAlertWithTitle:@"结束服务" action:^{
                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    break;
                }
                case BATChatRoomState_CutConnection:{

                }

            }
            break;
        }
        case kDoctorServerVideoType: {

            switch (model.State) {
                case BATChatRoomState_Invalid: {

                    break;
                }
                case BATChatRoomState_NoVisit: {

                    break;
                }
                case BATChatRoomState_Waiting: {


                    break;
                }
                case BATChatRoomState_Consulting: {
                    [self.alert dismissViewControllerAnimated:YES completion:nil];

                    break;
                }
                case BATChatRoomState_Consulted: {

                    break;
                }
                case BATChatRoomState_Calling: {

                    break;
                }
                case BATChatRoomState_Leaving: {
                    //医生离开
                    [self showCallingAlertWithTitle:@"结束服务" action:^{
                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];

                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    break;
                }
                case BATChatRoomState_CutConnection:{

                }

            }
            
            break;
        }
        case kDoctorServerHomeDoctor: {
            
            break;
        }
        case kDoctorServerRemote: {
            
            break;
        }
    }
}


- (void)showCallingAlertWithTitle:(NSString *)title action:(void (^)())action {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        //患者取消医生离开状态，继续音视频
        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];

    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:action];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];

    self.alert = alert;
}

#pragma mark - net
//改变状态
- (void)changeRoomStateRequestWithState:(BATChatRoomState)state {

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateRoomState" parameters:@{@"ChannelID":self.AGDKeyChannel,@"State":@(state)} type:kGET success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
}

#pragma  mark - pagesLayout
- (void)pagesLayout{
    
    /**
     *  判断手机型号，调整整体布局
     */
    CGFloat height;
    if(iPhone5){
        height = 40;
    }else if(iPhone6){
        height = 50;
    }else if(iPhone6p){
        height = 64;
    }else{
        height = 64;
    }
    
    WEAK_SELF(self);
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.view addSubview:self.remoteBGView];
    [self.remoteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.view addSubview:self.remoteView];
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.view addSubview:self.doctorImageView];
    [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(75);
    }];
    
    [self.view addSubview:self.doctorNameLable];
    [self.doctorNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.doctorImageView.mas_top).offset(5);
        make.left.equalTo(self.doctorImageView.mas_right).offset(20);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(100);
    }];
    
    
    [self.view addSubview:self.timeImageView];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.doctorNameLable.mas_bottom).offset(13);
        make.left.equalTo(self.doctorImageView.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    
    [self.view addSubview:self.talkTimeLabel];
    [self.talkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.doctorNameLable.mas_bottom).offset(13);
        make.left.equalTo(self.timeImageView.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.localBGView];
    [self.localBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(140);
        make.width.mas_equalTo(95);
    }];
    
    [self.localBGView addSubview:self.localImageBGView];
    [self.localImageBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.localBGView.mas_top);
        make.left.equalTo(self.localBGView.mas_left);
        make.right.equalTo(self.localBGView.mas_right);
        make.bottom.equalTo(self.localBGView.mas_bottom);
    }];
    
    [self.localBGView addSubview:self.localView];
    [self.localView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.localBGView.mas_top);
        make.left.equalTo(self.localBGView.mas_left);
        make.right.equalTo(self.localBGView.mas_right);
        make.bottom.equalTo(self.localBGView.mas_bottom);
    }];
    
    
    [self.view addSubview:self.hangUpBtn];
    [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.view.mas_bottom).offset(-height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
    }];
    
    if(self.chatType == BATChatType_Video){
        [self.view addSubview:self.muteBtn];
        [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-height/3.0);
            make.centerX.equalTo(self.view.mas_centerX).offset(-height*2);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(45);
        }];
        
        
        [self.view addSubview:self.closeCameraBtn];
        [self.closeCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-height/3.0);
            make.centerX.equalTo(self.view.mas_centerX).offset(height*2);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(45);
        }];
        
    }else{
        [self.view addSubview:self.muteBtn];
        [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-height);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(45);
        }];
    }
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_bg_image"]];
    }
    return _bgImageView;
}

- (UIImageView *)doctorImageView{
    if (!_doctorImageView) {
        _doctorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        _doctorImageView.layer.cornerRadius = 30;
        _doctorImageView.clipsToBounds = YES;
    }
    return _doctorImageView;
}

- (UILabel *)doctorNameLable{
    if (!_doctorNameLable) {
        _doctorNameLable = [[UILabel alloc]init];
        _doctorNameLable.font = [UIFont systemFontOfSize:18];
        _doctorNameLable.textAlignment = NSTextAlignmentLeft;
        _doctorNameLable.textColor = [UIColor whiteColor];
        _doctorNameLable.text = @"王医生";
    }
    return _doctorNameLable;
}

- (UIImageView *)timeImageView{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_time_image"]];
    }
    return _timeImageView;
}

- (UILabel *)talkTimeLabel{
    if (!_talkTimeLabel) {
        _talkTimeLabel = [[UILabel alloc]init];
        _talkTimeLabel.font = [UIFont systemFontOfSize:15];
        _talkTimeLabel.textAlignment = NSTextAlignmentLeft;
        _talkTimeLabel.textColor = [UIColor whiteColor];
        _talkTimeLabel.text = @"00:00:00";
    }
    return _talkTimeLabel;
}

- (UIView *)localBGView{
    if (!_localBGView) {
        _localBGView = [[UIView alloc]init];
        _localBGView.backgroundColor = [UIColor clearColor];
    }
    return  _localBGView;
}

- (UIView *)localView{
    if (!_localView) {
        _localView = [[UIView alloc]init];
        _localView.backgroundColor = [UIColor clearColor];
    }
    return  _localView;
}

- (UIImageView *)localImageBGView{
    if (!_localImageBGView) {
        _localImageBGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_bg_image"]];
    }
    return _localImageBGView;
}

- (UIView *)remoteBGView{
    if (!_remoteBGView) {
        _remoteBGView = [[UIView alloc]init];
        _remoteBGView.backgroundColor = UIColorFromRGB(0, 0, 0, 0.3);
    }
    return  _remoteBGView;
}

- (UIView *)remoteView{
    if (!_remoteView) {
        _remoteView = [[UIView alloc]init];
        _remoteView.backgroundColor = [UIColor clearColor];
    }
    return  _remoteView;
}

- (UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _muteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_muteBtn setTitle:@"静音" forState:UIControlStateNormal];
        [_muteBtn setTitle:@"静音" forState:UIControlStateSelected];
        [_muteBtn setImage:[UIImage imageNamed:@"video_mute_off_image"] forState:UIControlStateNormal];
        [_muteBtn setImage:[UIImage imageNamed:@"video_mute_image"] forState:UIControlStateSelected];
        _muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_muteBtn setTitleEdgeInsets:UIEdgeInsetsMake(65,-45,20,0)];
        [_muteBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 0,0,0)];
        [_muteBtn addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIButton *)closeCameraBtn{
    if (!_closeCameraBtn) {
        _closeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeCameraBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_closeCameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
        [_closeCameraBtn setTitle:@"摄像头" forState:UIControlStateSelected];
        [_closeCameraBtn setImage:[UIImage imageNamed:@"video_camera_image"] forState:UIControlStateNormal];
        [_closeCameraBtn setImage:[UIImage imageNamed:@"video_camera_off_image"] forState:UIControlStateSelected];
        _closeCameraBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_closeCameraBtn setTitleEdgeInsets:UIEdgeInsetsMake(65,-45,20,0)];
        [_closeCameraBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 0,0,0)];
        [_closeCameraBtn addTarget:self action:@selector(closeCameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeCameraBtn;
}

- (UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"video_hang_up_iamge"] forState:UIControlStateNormal];
        [_hangUpBtn addTarget:self action:@selector(hungUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hangUpBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
