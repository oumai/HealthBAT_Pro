//
//  BATTIMManager.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTIMManager.h"
#import "BATAppDelegate+BATResetLogin.h"
#import "BATAppDelegate+BATTabbar.h"//红点

//#import "BATLoginModel.h"

#import "BATTIMDataModel.h"

@implementation BATTIMManager

+ (BATTIMManager *)sharedBATTIM
{
    static BATTIMManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATTIMManager alloc] init];
    });
    return instance;
}

#pragma mark - 登录/注销
- (void)bat_loginTIM{
    
    BATTIMDataModel *TIMData = LOGIN_TIM_INFO;
    
    if (!TIMData) {
        return;
    }
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    
    login_param.accountType = TIMData.Data.accountType;
    login_param.identifier = TIMData.Data.identifier;
    login_param.userSig = TIMData.Data.userSig;
    login_param.appidAt3rd = TIMData.Data.sdkAppID;
    login_param.sdkAppId = [TIMData.Data.sdkAppID intValue];
    
    [[TIMManager sharedInstance] setLogLevel:TIM_LOG_NONE];
    [[TIMManager sharedInstance] initSdk:[TIMData.Data.sdkAppID intValue]];
    [[TIMManager sharedInstance] login: login_param succ:^(){
        DDLogDebug(@"登录腾讯IM成功");
        
        //监听登录状态
        [[TIMManager sharedInstance] setUserStatusListener:self];
        
        //监听接收消息
        [[TIMManager sharedInstance] setMessageListener:self];
        
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"登录腾讯IM失败: %d->%@", code, err);
        
    }];
}

- (void)bat_loginOutTIM{
    
    [[TIMManager sharedInstance] logout:^() {
        DDLogDebug(@"登出腾讯IM成功");
        
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"登出腾讯IM失败: code=%d err=%@", code, err);
        
    }];
}

- (void)bat_getLoginUser{
    
    [[TIMManager sharedInstance] getLoginUser];
}

- (BOOL)bat_getLoginStatus {
    
    if ([[TIMManager sharedInstance] getLoginStatus] == TIM_STATUS_LOGINED) {
        return YES;
    }
    else {
        return NO;
    }
}
#pragma mark - 用户状态
/**
 *  踢下线通知
 */
- (void)onForceOffline {
    
    [self showAlertWithMessage:@"您的帐号在另一台设备登录!"];
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err {
    
    [self showAlertWithMessage:@"帐号异常，请重新登录"];
    
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired {
    
    [self showAlertWithMessage:@"帐号异常，请重新登录"];
}



- (void)showAlertWithMessage:(NSString *)message {
    
    //清空极光推送别名
    BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate bat_logout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BATuserOnForceOfflineNotification object:nil];
    });
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alert addAction:okAction];
    UIWindow *mainWindow = MAIN_WINDOW;
    [mainWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 消息收发

- (TIMConversation *)bat_currentConversationWithType:(TIMConversationType)type receiver:(NSString *)receiver {
    
    self.currentConversation = [[TIMManager sharedInstance] getConversation:type receiver:receiver];
    return self.currentConversation;
}

- (void)bat_sendMessage:(TIMMessage *)message success:(void (^)(void))success failure:(void (^)(int code, NSString *msg))failure {
    
    [self.currentConversation sendMessage:message succ:^{
        if (success) {
            success();
        }
    } fail:^(int code, NSString *msg) {
        if (failure) {
            failure(code,msg);
        }
    }];
}

- (void)bat_MessageListener:(id<TIMMessageListener>)listener {
    
    [[TIMManager sharedInstance] removeMessageListener:self];
    [[TIMManager sharedInstance] setMessageListener:listener];
}

- (void)bat_removeMessagelistener:(id<TIMMessageListener>)listener {
    
    self.currentConversation = nil;
    [[TIMManager sharedInstance] removeMessageListener:listener];
    [[TIMManager sharedInstance] setMessageListener:self];
}

//收到消息，全局状态
- (void)onNewMessage:(NSArray *)msgs {
    
    //消息提醒，主要针对咨询的消息提醒
    
    NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:oldArr];
    
    DDLogInfo(@"已存储的订单消息标识===%@===",newArr);
    
    
    for (TIMMessage *message in msgs) {
        
        //订单结束的时候，如果TIM还是联通的话，会发来一条订单结束的自定义消息，屏蔽掉
        int cnt = [message elemCount];
        if (cnt > 1) {
            //通常是多条数据一起过来，类似于图文和数字一起，一般情况一条一条来
            for (int k=0; k<cnt; k++) {
                TIMElem * elem = [message getElem:k];
                if ([elem isKindOfClass:[TIMCustomElem class]]) {
                    // 系统消息,PASS
                    DDLogInfo(@"1111订单结束系统消息,PASS");
                    break;
                }else{
                    //不是系统消息，判断
                    TIMConversation *conversation = [message getConversation];
                    
                    NSString *channelID = [NSString stringWithFormat:@"%@",conversation];
                    
                    DDLogInfo(@"1111全局消息===%@===",channelID);
                    
                    //购买订单会生成一个消息字符串和订单字符串,直接Pass
                    if([channelID isEqualToString:@"System Message"]){
                        
                        //做标识，下一条不保存
                        NSUserDefaults *SystemMessageDefaults = [NSUserDefaults standardUserDefaults];
                        [SystemMessageDefaults setBool:YES forKey:@"Get_A_SystemMessage"];
                        [SystemMessageDefaults synchronize];
                        DDLogInfo(@"购买订单系统消息,PASS");
                        
                        return;
                    }
                    
                    if (newArr.count == 0) {
                        [newArr addObject:channelID];
                    }else{
                        for (NSInteger i=0;i<newArr.count;i++) {
                            NSString *oldChannelID = newArr[i];
                            
                            if([channelID isEqualToString:oldChannelID]){
                                break;
                            }
                            
                            if (![channelID isEqualToString:oldChannelID] && i == newArr.count - 1) {
                                //比较到数组最后一个还没有重复，这添加会话
                                //同个订单的消息，不重复标识，查看后会清除这个标识
                                [newArr addObject:channelID];
                            }
                        }
                    }
                    
                }
            }
            
        }else{
            TIMElem * elem = [message getElem:0];
            if ([elem isKindOfClass:[TIMCustomElem class]]) {
                // 系统消息，PASS
                DDLogInfo(@"0000订单结束系统消息,PASS");
                
                TIMCustomElem * customElem = (TIMCustomElem * )elem;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                //处方单的自定义消息
                if ([customElem.ext isEqualToString:@"Order.Buy.Recipe"] || [customElem.ext isEqualToString:@"Recipe.Preview"]) {
                   
                    
                }
                
                //服务结束
                if ([customElem.ext isEqualToString:@"Room.Hangup"]) {
                    
                    
                }
                
#pragma clang diagnostic pop
                
                break;
            }else{
                //不是系统消息
                TIMConversation *conversation = [message getConversation];
                
                NSString *channelID = [NSString stringWithFormat:@"%@",conversation];
                
                DDLogInfo(@"0000全局消息===%@===",channelID);
                
                //购买订单会生成一个消息字符串和订单字符串,直接Pass
                if([channelID isEqualToString:@"System Message"]){
                    
                    //做标识，吓一跳不保存
                    NSUserDefaults *SystemMessageDefaults = [NSUserDefaults standardUserDefaults];
                    [SystemMessageDefaults setBool:YES forKey:@"Get_A_SystemMessage"];
                    [SystemMessageDefaults synchronize];
                    
                    return;
                }
                
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"Get_A_SystemMessage"] == YES ){
                    //之前两条条是系统消息，这条PASS：
                    //原因：购买订单完成的时候也会推消息，而且是一条一条的推三条过来，二条是System Message，一条是14999这样的
                    DDLogInfo(@"购买订单系统消息,PASS");
                    NSUserDefaults *SystemMessageDefaults = [NSUserDefaults standardUserDefaults];
                    [SystemMessageDefaults setBool:NO forKey:@"Get_A_SystemMessage"];
                    [SystemMessageDefaults synchronize];
                    return;
                    
                }
                
                if (newArr.count == 0) {
                    [newArr addObject:channelID];
                }else{
                    for (NSInteger i=0;i<newArr.count;i++) {
                        NSString *oldChannelID = newArr[i];
                        
                        if([channelID isEqualToString:oldChannelID]){
                            break;
                        }
                        
                        if (![channelID isEqualToString:oldChannelID] && i == newArr.count - 1) {
                            //比较到数组最后一个还没有重复，这添加会话
                            //同个订单的消息，不重复标识，查看后会清除这个标识
                            [newArr addObject:channelID];
                        }
                    }
                }
                
            }
        }
    }
    
    DDLogInfo(@"新存储的订单消息标识===%@===",newArr);
    
    if (newArr.count > 0) {
        //加通知，刷新提醒标志
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Get_New_Message_From_Doctor" object:nil];
        
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        
        //消息中心角标变化
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE" object:nil];
        
        //设置健康咨询tabbar角标
//        BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate setTarBarWithMessageCount:newArr.count];
    }
    
    //保存到本地
    NSUserDefaults *channleDefaults = [NSUserDefaults standardUserDefaults];
    [channleDefaults setObject:newArr forKey:@"channelIDArray"];
    [channleDefaults synchronize];
}

//#pragma maerk -  新消息通知
//
//+ (ActionState)parseActionStateWithChatType:(BATChatType)chatType
//                              chatRoomState:(BATChatRoomState)chatRoomState
//                      previousChatRoomState:(BATChatRoomState)previousChatRoomState{
//    if (chatType == BATChatType_Audio) {//患者端音频
//        switch (chatRoomState) {
//            case BATChatRoomState_Waiting: {//医生端取消呼叫
//                if (previousChatRoomState == BATChatRoomState_Waiting) {
//                    return ActionState_PatientAudioWaiting;
//                }
//                return ActionState_DoctorAudioCanceledCalling;
//            }
//            case BATChatRoomState_Consulted: {
//                return ActionState_DoctorAudioHangupCalling;
//            }
//            case BATChatRoomState_Consulting: {
//                return ActionState_PatientAudioAnswer;
//            }
//                break;
//            case BATChatRoomState_Calling: {
//                return ActionState_DoctorAudioCalling;
//            }
//                break;
//            case BATChatRoomState_Invalid: {
//
//            }
//                break;
//            case BATChatRoomState_Leaving: {
//                return ActionState_DoctorAudioHangupCalling;
//            }
//            case BATChatRoomState_NoVisit: {
//
//            }
//            default:
//                break;
//        }
//    } else if (chatType == BATChatType_Video) {//患者端视频
//        switch (chatRoomState) {
//            case BATChatRoomState_Waiting: {//医生端取消呼叫
//                if (previousChatRoomState == BATChatRoomState_Waiting) {
//                    return ActionState_PatientVideoWaiting;
//                }
//                return ActionState_DoctorVideoCanceledCalling;
//            }
//            case BATChatRoomState_Consulted: {
//
//            }
//                break;
//            case BATChatRoomState_Consulting: {
//
//            }
//            case BATChatRoomState_Calling: {
//                return ActionState_DoctorVideoCalling;
//            }
//            case BATChatRoomState_Invalid: {
//
//            }
//                break;
//            case BATChatRoomState_Leaving: {
//
//            }
//                break;
//            case BATChatRoomState_NoVisit: {
//
//            }
//            default:
//                break;
//        }
//    }
//    return ActionState_PatientOther;
//}


///**
// *  新消息通知
// *
// *  @param msgs 新消息列表，TIMMessage 类型数组
// */
//- (void)listenWithIMAUser:(IMAUser *)user{
//    IMAConversation *conversation = [[IMAPlatform sharedInstance].conversationMgr chatWith:user];
//    __weak typeof(self) weakSelf = self;
//    conversation.receiveMsg = ^(NSArray *imamsgList, BOOL succ) {
//        [weakSelf onReceiveNewMsg:imamsgList succ:succ];
//    };
//}
//
//- (void)onReceiveNewMsg:(NSArray *)imamsgList succ:(BOOL)succ {
//    NSInteger count = [imamsgList count];
//    for (NSInteger i = 0; i < count; i++) {
//        IMAMsg *imaMsg = imamsgList[i];
//        [self listenWithIMAMsg:imaMsg];
//    }
//}
//
//- (void)listenWithIMAMsg:(IMAMsg *)msg {
//    BATChatRoomState state = [msg getChatRoomState];
//    if (state != BATChatRoomState_Invalid) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(callingSystemListener:chatRoomState:sendByMe:)]) {
//            [self.delegate callingSystemListener:self chatRoomState:state sendByMe:[msg isMineMsg]];
//        }
//    }
//}



#pragma mark  - 加群操作
- (void)bat_joinGroup:(NSString *)groupID msg:(NSString*)msg success:(void (^)(void))success failure:(void (^)(void))failure{
    
    [[TIMGroupManager sharedInstance] JoinGroup:groupID msg:msg succ:^(){
        DDLogDebug(@"Join Succ");
        if (success) {
            success();
        }
    }fail:^(int code, NSString * err) {
        DDLogDebug(@"code=%d, err=%@", code, err);
        if (failure) {
            failure();
        }
    }];
    
}

- (void)bat_quitGroup:(NSString *)groupID success:(void (^)(void))success failure:(void (^)(void))failure{
    
    [[TIMGroupManager sharedInstance] QuitGroup:@"TGID1JYSZEAEQ" succ:^() {
        DDLogDebug(@"qiut Succ");
        if (success) {
            success();
        }
    } fail:^(int code, NSString* err) {
        DDLogDebug(@"qiut fail code=%d, err=%@", code, err);
        if (failure) {
            failure();
        }
    }];
}

@end
