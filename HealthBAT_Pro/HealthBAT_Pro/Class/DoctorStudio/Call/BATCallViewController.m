//
//  BATCallViewController.m
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "BATCallViewController.h"
#import "BATAgoraSignalingManager.h"
#import "BATAgoraManager.h"

#import "BATLoginModel.h"
#import "BATPerson.h"
#import "BATLoginModel.h"

@interface BATCallViewController ()

//计时器
@property (strong, nonatomic) NSTimer *durationTimer;

//持续时间
@property (nonatomic) NSUInteger duration;

@property (nonatomic,assign) NSInteger callTime;
@property (nonatomic,strong) NSTimer *callTimer;

@end

@implementation BATCallViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinChannel:) name:@"BATCallJoinChannelNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endByPeer:) name:@"BATCallEndByPeerNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refusedByPeer:) name:@"BATCallRefusedByPeerNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToCalling) name:@"BATCallAcceptedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAnswer) name:@"BATCallNoAnswerNotification" object:nil];

        
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.callView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.doctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
    self.callView.nameLabel.text = self.doctorName;
    
    [self updateUI];
    
    if (self.callState == BATCallState_Call) {
        //主动呼叫
        [self channelInviterUser];
        self.callTime = 0;
        WEAK_SELF(self);
        self.callTimer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
            STRONG_SELF(self);
            self.callTime ++;
            
            if (self.callTime == 120) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallNoAnswerNotification" object:nil];

                [timer invalidate];
            }
            
        } repeats:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_durationTimer != nil) {
        [_durationTimer invalidate];
        _durationTimer = nil;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Action
/**
 *  时间变更
 */
- (void)updateTalkTimeLabel
{
    self.duration++;
    NSUInteger seconds = self.duration % 60;
    NSUInteger minutes = (self.duration - seconds) / 60;
    NSUInteger hours = self.duration / 3600;
    self.callView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
}

- (void)updateUI
{
    if (self.callState == BATCallState_Call) {
//        self.callView.networkStateView.networkStateImageView.image = [UIImage imageNamed:@"img-ll-3"];
//        self.callView.networkStateView.networkStateLabel.text = @"网络状态不好";
//        self.callView.networkStateView.hidden = NO;

        self.callView.callStateLabel.hidden = NO;
        self.callView.callStateLabel.text = @"正在呼叫，请耐心等待...";

        self.callView.timeLabel.hidden = YES;
        self.callView.cancelButton.hidden = NO;
        self.callView.hangUpButton.hidden = YES;
        self.callView.answerButton.hidden = YES;
        
    } else if (self.callState == BATCallState_Answer) {
//        self.callView.networkStateView.networkStateImageView.image = [UIImage imageNamed:@"img-ll-3"];
//        self.callView.networkStateView.networkStateLabel.text = @"网络状态不好";
//        self.callView.networkStateView.hidden = YES;
        
        self.callView.callStateLabel.hidden = NO;
        self.callView.callStateLabel.text = @"正在呼叫你，是否接通";

        self.callView.timeLabel.hidden = YES;
        self.callView.cancelButton.hidden = YES;
        self.callView.hangUpButton.hidden = NO;
        self.callView.answerButton.hidden = NO;
    } else if (self.callState == BATCallState_Calling) {

//        self.callView.networkStateView.networkStateImageView.image = [UIImage imageNamed:@"img-ll-3"];
//        self.callView.networkStateView.networkStateLabel.text = @"网络状态不好";
//        self.callView.networkStateView.hidden = NO;

        self.callView.callStateLabel.hidden = YES;
        self.callView.timeLabel.hidden = NO;
        self.callView.cancelButton.hidden = NO;
        self.callView.hangUpButton.hidden = YES;
        self.callView.answerButton.hidden = YES;
    }
}

/**
 加入引擎频道
 */
- (void)joinChannel:(NSNotification *)notif
{
    
    
    
    self.channelKey = [notif object];
    BATLoginModel *login = LOGIN_INFO;
    
    [[BATAgoraManager shared] joinCahannel:self.channelKey channelName:self.roomID info:@"" uid:login.Data.ID joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        DDLogDebug(@"加入引擎频道成功");

    }];
}


/**
 更改UI
 */
- (void)changeToCalling {
    
    [self.callTimer invalidate];
    
    self.callState = BATCallState_Calling;
    [self updateUI];
    self.duration = 0;
    self.callView.timeLabel.text = [NSString stringWithFormat:@"00:00:00"];
    _durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
}

/**
 对方结束呼叫
 
 @param notif 通知数据
 */
- (void)endByPeer:(NSNotification *)notif
{
    [self.callTimer invalidate];
    [self showErrorWithText:@"医生已经退出诊室" completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

/**
 对方拒绝呼叫
 
 @param notif 通知数据
 */
- (void)refusedByPeer:(NSNotification *)notif
{
    [self.callTimer invalidate];

    [self showErrorWithText:@"医生正在忙碌中，请稍后再拨" completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //结束呼叫
    [[BATAgoraSignalingManager shared] channelInviteEnd:self.roomID account:self.doctorID];
}

- (void)noAnswer
{
    [self.callTimer invalidate];

    [self showErrorWithText:@"医生忙碌中请重新发送请求，可以选择继续呼叫或者稍后再试" completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //结束呼叫
    [[BATAgoraSignalingManager shared] channelInviteEnd:self.roomID account:self.doctorID];
}


/**
 呼叫用户
 */
- (void)channelInviterUser
{
    if (![[BATAgoraSignalingManager shared] isOnline]) {
        BATLoginModel *login = LOGIN_INFO;
        [[BATAgoraSignalingManager shared] login:[NSString stringWithFormat:@"%ld",(long)login.Data.ID] token:login.Data.AgoraToken deviceID:nil complete:^(BOOL success) {
            
            BATPerson *person = PERSON_INFO;
            
            NSDictionary *dic = @{
                                  @"Name":person.Data.UserName,
                                  @"PhotoPath":person.Data.PhotoPath,
                                  @"OrderNo":self.orderNo,
                                  };
            
            [[BATAgoraSignalingManager shared] channelJoin:self.roomID complete:^(BOOL success) {
                
                if (success) {
                    [[BATAgoraSignalingManager shared] channelInviteUser2:self.roomID account:self.doctorID extra: [Tools dataTojsonString:dic]];
                }
                else {
                    
                    [self showErrorWithText:@"医生忙碌中请重新发送请求，可以选择继续呼叫或者稍后再试"];
                }
            }];
        }];
    }
    
    BATPerson *person = PERSON_INFO;
    
    NSDictionary *dic = @{
                          @"Name":person.Data.UserName,
                          @"PhotoPath":person.Data.PhotoPath,
                          @"OrderNo":self.orderNo,
                          };
   
    [[BATAgoraSignalingManager shared] channelJoin:self.roomID complete:^(BOOL success) {
        
        if (success) {
            [[BATAgoraSignalingManager shared] channelInviteUser2:self.roomID account:self.doctorID extra: [Tools dataTojsonString:dic]];
        }
        else {
            
            [self showErrorWithText:@"医生忙碌中请重新发送请求，可以选择继续呼叫或者稍后再试"];
        }
    }];
    
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.callView];
    
    WEAK_SELF(self);
    [self.callView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATCallView *)callView
{
    if (_callView == nil) {
        _callView = [[BATCallView alloc] init];
        
        _callView.nameLabel.text = self.doctorName;
        _callView.doctorTitleLabel.text = self.doctorTitle;
        _callView.hospitalAndDepartmentLabel.text = [NSString stringWithFormat:@"%@ %@",self.hospitalName,self.departmentName];

        
        WEAK_SELF(self);
        _callView.cancelButton.callOptBlock = ^{
            //取消
            STRONG_SELF(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self.callTimer invalidate];

            //结束呼叫
            [[BATAgoraSignalingManager shared] channelInviteEnd:self.roomID account:self.doctorID];
            
        };
        
        _callView.hangUpButton.callOptBlock = ^{
            //挂断
            STRONG_SELF(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self.callTimer invalidate];

            
            [[BATAgoraSignalingManager shared] channelInviteRefuse:self.roomID account:self.doctorID extra:nil];
            
            //离开信令频道
            [[BATAgoraSignalingManager shared] channelLeave:self.roomID];
            
            //离开引擎频道
            [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
                
            }];
        };
        
        _callView.answerButton.callOptBlock = ^{
            //接听
            STRONG_SELF(self);
            
            [self.callTimer invalidate];

            [self changeToCalling];
            
            [[BATAgoraSignalingManager shared] channelInviteAccept:self.roomID account:self.doctorID];
            
            [self joinChannel:[NSNotification notificationWithName:@"BATCallJoinChannelNotification" object:self.channelKey]];
        };
    }
    return _callView;
}

@end
