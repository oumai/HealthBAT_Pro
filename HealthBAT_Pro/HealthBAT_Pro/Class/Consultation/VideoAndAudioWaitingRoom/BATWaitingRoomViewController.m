//
//  BATWaitingRoomViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2016/10/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWaitingRoomViewController.h"
#import "BATNewMessageModel.h"
#import "BATMediaConfigModel.h"
#import "BATRoomInfoModel.h"
#import "BATWaitingCountModel.h"
#import "BATConsultationDoctorDetailModel.h"

#import "BATWaterLine.h"
#import "BATAudioView.h"
#import "MQChatViewManager.h"

#import "BATTIMDataModel.h"

#import "UIAlertController+BATSupportedInterfaceOrientations.h"

@interface BATWaitingRoomViewController ()<TIMMessageListener>

//渐变背景
@property (nonatomic,strong) UIImageView *bgViewImage;
//等待就诊人
//@property (nonatomic,strong) UILabel *waitingCountLabel;
@property (nonatomic,strong) UIImageView *doctorHeaderImageView;
@property (nonatomic,strong) UILabel *doctorNameLabel;
@property (nonatomic,strong) UILabel *doctorTitleLable;
@property (nonatomic,strong) UILabel *deptLabel;
@property (nonatomic,strong) UILabel *hospitalLable;
@property (nonatomic,strong) UILabel *promptLable;
@property (nonatomic,strong) UILabel *waitUpLable;

@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *downButton;
@property (nonatomic,strong) UIButton *upButton;

@property (nonatomic,strong) BATNewMessageModel *model;

@property (nonatomic,strong) UIAlertController *alert;

@property (nonatomic,strong) BATWaterLine *waterLine;
@property (nonatomic,strong) BATAudioView *batAudioView;

@property (nonatomic,assign) BOOL isJoinedAudioView;

@property (nonatomic,assign) BOOL isNotShowRemind;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSString *keyStr;
@end

@implementation BATWaitingRoomViewController

- (void)dealloc{
    [self.timer invalidate];
    self.batAudioView =  nil;
    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.title = @"候诊室";
    
    _isNotShowRemind = NO;
    _keyStr = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitVideoChatViewOfDissVC:) name:@"QUIT_CHATView_OF_VIDEO" object:nil];
    
    self.isJoinedAudioView = NO;

    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x5d9fea, 1)] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.view.backgroundColor = UIColorFromHEX(0x5d9fea, 1);

    [self layoutPages];
    
    //更改状态候诊中
    [self changeRoomStateRequestWithState:BATChatRoomState_Waiting];
    //获取对话
    [[BATTIMManager sharedBATTIM] bat_currentConversationWithType:TIM_GROUP receiver:[NSString stringWithFormat:@"%ld",(long)self.roomID]];
    //添加消息监听
    [[BATTIMManager sharedBATTIM] bat_MessageListener:self];

//    [self roomInfoRequest];
//    [self waitingCountRequest];
    [self doctorInfoRequest];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(remindDoctorNoTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}


- (void)remindDoctorNoTime{
    
    if (_isNotShowRemind == NO) {
        
        [self.timer invalidate];
        //提示开启定
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"医生忙碌中，请重新发送请求！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"稍后再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
            [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction * goOnAction = [UIAlertAction actionWithTitle:@"继续呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //更改状态候诊中
            self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(remindDoctorNoTime) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [self changeRoomStateRequestWithState:BATChatRoomState_Waiting];
        }];
        [alert addAction:okAction];
        [alert addAction:goOnAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}


/**
 视频成功退出通知

 @param info nil
 */
- (void)quitVideoChatViewOfDissVC:(NSNotification *)info{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
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
    self.model = [BATNewMessageModel mj_objectWithKeyValues:dic];

    switch (self.model.ServiceType) {
        case kDoctorServerWordImageType: {

            break;
        }
        case kDoctorServerAudioType: {
            //音频
            switch (self.model.State) {
                case BATChatRoomState_NoVisit: {
                    
                    self.cancelButton.hidden = NO;
                    self.downButton.hidden = YES;
                    self.upButton.hidden = YES;
                    
                    self.doctorTitleLable.hidden = NO;
                    self.hospitalLable.hidden = NO;
                    self.deptLabel.hidden = NO;
                    self.promptLable.hidden = NO;
                    self.waitUpLable.hidden = YES;

                    break;
                }
                case BATChatRoomState_Waiting: {
//                    [self.alert dismissViewControllerAnimated:YES completion:nil];
                    
                    self.cancelButton.hidden = NO;
                    self.downButton.hidden = YES;
                    self.upButton.hidden = YES;
                    
                    self.doctorTitleLable.hidden = NO;
                    self.hospitalLable.hidden = NO;
                    self.deptLabel.hidden = NO;
                    self.promptLable.hidden = NO;
                    self.waitUpLable.hidden = YES;

                    break;
                }
                case BATChatRoomState_Consulting: {

                    break;
                }
                case BATChatRoomState_Consulted: {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BATENDSEVERICE object:nil];
                    
                    [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                    
                    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                    
                    [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                        
                    }];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                }
                case BATChatRoomState_Calling: {
                    
                    self.cancelButton.hidden = YES;
                    self.downButton.hidden = NO;
                    self.upButton.hidden = NO;
                    
                    self.doctorTitleLable.hidden = YES;
                    self.hospitalLable.hidden = YES;
                    self.deptLabel.hidden = YES;
                    self.promptLable.hidden = YES;
                    self.waitUpLable.hidden = NO;
                    //呼叫中
//                    [self showCallingAlertWithTitle:@"医生向您请求音频通话" action:^{
//
//                        [self.timer invalidate];
//                        _isNotShowRemind = YES;
//                        
//                        DDLogError(@"开始音频");
////                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
//                        [self medioConfigRequest];
//
//                    }];
                    break;
                }
                case BATChatRoomState_Leaving: {
                    //医生离开
                    
                    [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
                    
                    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                    
                    [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                        
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
//                    [self showCancelAlertWithTitle:@"结束服务" action:^{
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:BATENDSEVERICE object:nil];
//                        
//                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
//                        
//                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
//                        
//                        [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
//                            
//                        }];
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }];
                    break;
                }

            }
            break;
        }
        case kDoctorServerVideoType: {

            switch (self.model.State) {
                case BATChatRoomState_NoVisit: {
                    self.cancelButton.hidden = NO;
                    self.downButton.hidden = YES;
                    self.upButton.hidden = YES;
                    
                    self.doctorTitleLable.hidden = NO;
                    self.hospitalLable.hidden = NO;
                    self.deptLabel.hidden = NO;
                    self.promptLable.hidden = NO;
                    self.waitUpLable.hidden = YES;
                    break;
                }
                case BATChatRoomState_Waiting: {

//                    [self.alert dismissViewControllerAnimated:YES completion:nil];
                    
                    self.cancelButton.hidden = NO;
                    self.downButton.hidden = YES;
                    self.upButton.hidden = YES;
                    
                    self.doctorTitleLable.hidden = NO;
                    self.hospitalLable.hidden = NO;
                    self.deptLabel.hidden = NO;
                    self.promptLable.hidden = NO;
                    self.waitUpLable.hidden = YES;

                    break;
                }
                case BATChatRoomState_Consulting: {

                    break;
                }
                case BATChatRoomState_Consulted: {
                    
                    [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
                    
                    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                    
                    [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                        
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    break;
                }
                case BATChatRoomState_Calling: {
                    //医生发起视频呼叫
//                    if (self.model.State == BATChatRoomState_Calling) {
                    
                        self.cancelButton.hidden = YES;
                        self.downButton.hidden = NO;
                        self.upButton.hidden = NO;
                        
                        self.doctorTitleLable.hidden = YES;
                        self.hospitalLable.hidden = YES;
                        self.deptLabel.hidden = YES;
                        self.promptLable.hidden = YES;
                        self.waitUpLable.hidden = NO;
                        
//                        [self showCallingAlertWithTitle:@"医生向您请求视频通话" action:^{
//                            DDLogError(@"开始视频");
//                            [self.timer invalidate];
//                            _isNotShowRemind = YES;
//                            [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
//                            [self medioConfigRequest];
//                        }];
//                    }
                    break;
                }
                case BATChatRoomState_Leaving: {
                    //医生离开

                    
                    [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
                    
                    [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                    
                    [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                        
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
//                    [self showCancelAlertWithTitle:@"结束服务" action:^{
//                        
//                        [self changeRoomStateRequestWithState:BATChatRoomState_Consulted];
//                        
//                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
//                        
//                        [_batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
//                            
//                        }];
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }];
                    break;
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

//- (void)showCallingAlertWithTitle:(NSString *)title action:(void (^)(void))action {
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //患者不接通，取消等待状态，返回订单页面
//        [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"接通" style:UIAlertActionStyleDestructive handler:action];
//    [alert addAction:cancelAction];
//    [alert addAction:confirmAction];
//    [self presentViewController:alert animated:YES completion:nil];
//
//    self.alert = alert;
//}


//医生结束订单直接结束
//- (void)showCancelAlertWithTitle:(NSString *)title action:(void (^)(void))action {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //患者点取消，取消医生离开状态
//        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];
//        
//    }];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:action];
//    [alert addAction:cancelAction];
//    [alert addAction:confirmAction];
//    [self presentViewController:alert animated:YES completion:nil];
//    
//    self.alert = alert;
//}

#pragma mark - net
//改变状态
- (void)changeRoomStateRequestWithState:(BATChatRoomState)state {

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateRoomState" parameters:@{@"ChannelID":@(self.roomID),@"State":@(state)} type:kGET success:^(id responseObject) {
        DDLogDebug(@"===============改变状态成功了===============");
        

        if (BATChatRoomState_Consulting == state) {
            //只有咨询需要走接口，其他接口操作没作用
            if(self.type == kDoctorServerAudioType){
                
                //最新聊天UI
                self.batAudioView = [[BATAudioView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.hospitalLable.frame)+15, SCREEN_WIDTH, 25)];
                self.batAudioView.backgroundColor = [UIColor clearColor];
                self.batAudioView.AGDKeyChannel = [NSString stringWithFormat:@"%ld",(long)self.roomID];
                self.batAudioView.AGDKeyVendorKey = _keyStr;
                [self.batAudioView joinWithKey:_keyStr andWithChannel:[NSString stringWithFormat:@"%ld",(long)self.roomID]];
                [self.view addSubview:self.batAudioView];
                
                //获取对话
                [[BATTIMManager sharedBATTIM] bat_currentConversationWithType:TIM_GROUP receiver:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",(long)self.roomID]]];
                
                self.isJoinedAudioView = YES;
                self.promptLable.hidden = YES;
                //            self.waitingCountLabel.hidden = YES;
                
                self.cancelButton.hidden = NO;
                self.downButton.hidden = YES;
                self.upButton.hidden = YES;
                self.waitUpLable.hidden = YES;
                
            }else if(self.type == kDoctorServerVideoType){
                
                //视频与图文结合
                
                //本地存储声网视频信息，退出时候 改变状态和信息
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"startVideo"];
                [[NSUserDefaults standardUserDefaults] setObject:_keyStr forKey:@"AGDKeyVendorKey"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.roomID] forKey:@"AGDKeyChannel"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
                [chatViewManager setNavTitleText:@"视频诊疗"];
                //            chatViewManager.chatViewStyle.enableIncomingAvatar = NO;
                //            chatViewManager.chatViewStyle.enableOutgoingAvatar = NO;
                [chatViewManager setInPutBarHide:NO];
                if (self.Gender == 0) {
                    //男
                    [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-nys"]];
                } else {
                    //女，或者未知
                    [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-ysv"]];
                }
                chatViewManager.chatViewStyle.enableRoundAvatar = YES;
                chatViewManager.chatViewStyle.outgoingBubbleImage = [UIImage imageNamed:@"chat-2"];
                chatViewManager.chatViewStyle.incomingBubbleImage = [UIImage imageNamed:@"chat-1"];
                chatViewManager.chatViewStyle.outgoingMsgTextColor = UIColorFromHEX(0xffffff, 1);
                chatViewManager.chatViewStyle.incomingMsgTextColor = UIColorFromHEX(0x333333, 1);
                
                [chatViewManager pushMQChatViewControllerInViewController:self];
            }

        }
        
    } failure:^(NSError *error) {
        DDLogDebug(@"===============改变状态失败了===============");
    }];
}

//获取房间信息
//- (void)roomInfoRequest {
//
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetRoomInfo" parameters:@{@"ChannelID":@(self.roomID)} type:kGET success:^(id responseObject) {
//
//        BATRoomInfoModel *roomInfo = [BATRoomInfoModel mj_objectWithKeyValues:responseObject];
//
//    } failure:^(NSError *error) {
//
//    }];
//}

//获取房间还有多少人
//- (void)waitingCountRequest {
//
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetRoomWaitingCount" parameters:@{@"DoctorID":self.doctorID,@"ChannelID":@(self.roomID)} type:kGET success:^(id responseObject) {
//
//        BATWaitingCountModel *waitingCount = [BATWaitingCountModel mj_objectWithKeyValues:responseObject];
//        self.waitingCountLabel.text = [NSString stringWithFormat:@"您前面还有%ld位候诊人，请等待医生呼叫",(long)waitingCount.Data];
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)doctorInfoRequest {

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDoctorDetail" parameters:@{@"doctorId":self.doctorID} type:kGET success:^(id responseObject) {

        BATConsultationDoctorDetailModel *doctor = [BATConsultationDoctorDetailModel mj_objectWithKeyValues:responseObject];
        [self.doctorHeaderImageView sd_setImageWithURL:[NSURL URLWithString:doctor.Data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        self.doctorNameLabel.text = doctor.Data.DoctorName;
        self.deptLabel.text = doctor.Data.DepartmentName;
        self.hospitalLable.text = doctor.Data.HospitalName;
        self.doctorTitleLable.text = doctor.Data.Title;
        
        
        
        CGSize deptSize = [self.deptLabel.text sizeWithAttributes:@{NSFontAttributeName : self.deptLabel.font}];
        CGSize hospitalSize = [self.hospitalLable.text sizeWithAttributes:@{NSFontAttributeName : self.hospitalLable.font}];
        CGFloat allWidth = (SCREEN_WIDTH - deptSize.width - hospitalSize.width - 20)/2.0;
        DDLogInfo(@"%f",allWidth);
        WEAK_SELF(self);
        [self.hospitalLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.view.mas_left).offset(allWidth);
            make.top.equalTo(self.doctorTitleLable.mas_bottom).offset(10);
        }];
        [self.deptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.hospitalLable.mas_right).offset(20);
            make.centerY.equalTo(self.hospitalLable);
        }];

    } failure:^(NSError *error) {

    }];
}
//多媒体配置信息请求
- (void)medioConfigRequest {
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"];
    BATTIMDataModel * TIMData = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSString *idconfig = TIMData.Data.identifier;

    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetMediaConfig" parameters:@{@"ChannelID":@(self.roomID),@"Identifier":idconfig} type:kGET success:^(id responseObject) {
        
        //单纯的声网音频
        BATMediaConfigModel *mediaConfig = [BATMediaConfigModel mj_objectWithKeyValues:responseObject];

        _keyStr = mediaConfig.Data.MediaChannelKey;
        
        [self changeRoomStateRequestWithState:BATChatRoomState_Consulting];

    } failure:^(NSError *error) {
        DDLogInfo(@"请求TIM配置信息失败！！！");
    }];
}


#pragma mark - layout
- (void)layoutPages {
    
    WEAK_SELF(self);
    [self.view addSubview:self.bgViewImage];
    [self.bgViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];

//    [self.view addSubview:self.waitingCountLabel];
//    [self.waitingCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.view.mas_top).offset(20);
//    }];

    [self.view addSubview:self.doctorHeaderImageView];
    [self.doctorHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.size.mas_equalTo(CGSizeMake(100,100));
    }];

    [self.view addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.doctorHeaderImageView.mas_bottom).offset(14);
    }];
    
    [self.view addSubview:self.doctorTitleLable];
    [self.doctorTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.waitUpLable];
    [self.waitUpLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(10);
    }];

    [self.view addSubview:self.deptLabel];
    [self.deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.top.equalTo(self.doctorTitleLable.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.hospitalLable];
    [self.hospitalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.doctorTitleLable.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.promptLable];
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.hospitalLable.mas_bottom).offset(40);
    }];
    
    [self.view addSubview:self.waterLine];
    [self.waterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.promptLable.mas_bottom).offset(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view);
        if (iPhone5) {
             make.bottom.equalTo(self.view.mas_bottom).offset(-30.0);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-58.5);
        }
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.downButton];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_left).offset(SCREEN_WIDTH/3.0*2);
        if (iPhone5) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-30.0);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-58.5);
        }
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.upButton];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_left).offset(SCREEN_WIDTH/3.0);
        if (iPhone5) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-30.0);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-58.5);
        }
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - getter

- (UIImageView *)bgViewImage{
    if (!_bgViewImage) {
        _bgViewImage = [[UIImageView alloc] init];
        _bgViewImage.image = [UIImage imageNamed:@"VAA-bg"];
    }

    return _bgViewImage;
}


- (UIButton *)cancelButton {

    if (!_cancelButton) {
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消" titleColor:[UIColor whiteColor] backgroundColor:nil backgroundImage:nil  Font:[UIFont systemFontOfSize:18]];
        [_cancelButton setImage:[UIImage imageNamed:@"VAA-qx"] forState:UIControlStateNormal];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelButton setImageEdgeInsets:UIEdgeInsetsMake(-35, 0.0, 0.0, 0.0)];
        [_cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -60, 0.0 ,0.0)];
        
        WEAK_SELF(self);
        [_cancelButton bk_whenTapped:^{
            STRONG_SELF(self);

            if (self.isJoinedAudioView) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否立即离开" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                    [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];

                    [self.batAudioView.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
                        // Myself leave status
                        [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                        [UIApplication sharedApplication].idleTimerDisabled = NO;
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                }];

                [alert addAction:cancelAction];
                [alert addAction:confirmAction];
                [self presentViewController:alert animated:YES completion:nil];
                self.alert = alert;
            
            }else{
                [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
                [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    return _cancelButton;
}

- (UIButton *)downButton {
    
    if (!_downButton) {
         WEAK_SELF(self);
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"挂断" titleColor:[UIColor whiteColor] backgroundColor:nil backgroundImage:nil  Font:[UIFont systemFontOfSize:18]];
        [_downButton setImage:[UIImage imageNamed:@"VAA-qx"] forState:UIControlStateNormal];
        _downButton.hidden = YES;
        _downButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_downButton setImageEdgeInsets:UIEdgeInsetsMake(-35, 0.0, 0.0, 0.0)];
        [_downButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -60, 0.0 ,0.0)];
        [_downButton bk_whenTapped:^{
                STRONG_SELF(self);
            
            [self changeRoomStateRequestWithState:BATChatRoomState_NoVisit];
            [[BATTIMManager sharedBATTIM] bat_removeMessagelistener:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _downButton;
}

- (UIButton *)upButton {
    
    if (!_upButton) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"接听" titleColor:[UIColor whiteColor] backgroundColor:nil backgroundImage:nil  Font:[UIFont systemFontOfSize:18]];
        [_upButton setImage:[UIImage imageNamed:@"VAA-jt"] forState:UIControlStateNormal];
        _upButton.hidden = YES;
        _upButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_upButton setImageEdgeInsets:UIEdgeInsetsMake(-35, 0.0, 0.0, 0.0)];
        [_upButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -60, 0.0 ,0.0)];
        WEAK_SELF(self);
        [_upButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.type == kDoctorServerAudioType) {
                DDLogError(@"开始音频");
                
                //该显示的继续显示
                self.doctorTitleLable.hidden = NO;
                self.hospitalLable.hidden = NO;
                self.deptLabel.hidden = NO;
                self.promptLable.hidden = YES;
                self.waitUpLable.hidden = YES;
                
                [self.timer invalidate];
                _isNotShowRemind = YES;
                [self medioConfigRequest];
            }else if (self.type == kDoctorServerVideoType){
                DDLogError(@"开始视频");
                [self.timer invalidate];
                _isNotShowRemind = YES;
                [self medioConfigRequest];
            }
            
        }];
    }
    return _upButton;
}

- (UIImageView *)doctorHeaderImageView {

    if (!_doctorHeaderImageView) {
        _doctorHeaderImageView = [[UIImageView alloc] init];
        _doctorHeaderImageView.layer.cornerRadius = 50;
        _doctorHeaderImageView.clipsToBounds = YES;
    }
    return _doctorHeaderImageView;
}

- (UILabel *)doctorNameLabel {

    if (!_doctorNameLabel) {
        _doctorNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _doctorNameLabel;
}

//- (UILabel *)waitingCountLabel {
//
//    if (!_waitingCountLabel) {
//        _waitingCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
//    }
//    return _waitingCountLabel;
//}


- (UILabel *)deptLabel{
    if (!_deptLabel) {
        _deptLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _deptLabel;
}

- (UILabel *)doctorTitleLable{
    if (!_doctorTitleLable) {
        _doctorTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _doctorTitleLable;
}

- (UILabel *)waitUpLable{
    if (!_waitUpLable) {
        _waitUpLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
        _waitUpLable.text = @"正在呼叫您，是否接通";
        _waitUpLable.hidden = YES;
    }
    return _waitUpLable;
}


- (UILabel *)hospitalLable{
    if (!_hospitalLable) {
        _hospitalLable = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _hospitalLable;
}

- (UILabel *)promptLable{
    if (!_promptLable) {
        _promptLable = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0xfffefe, 1) textAlignment:NSTextAlignmentCenter];
        _promptLable.text = @"正在呼叫，请您耐心等候...";
    }
    return _promptLable;
}

- (BATWaterLine *)waterLine{
    if (!_waterLine) {
        _waterLine = [[BATWaterLine alloc]init];
    }
    return _waterLine;
}


@end
