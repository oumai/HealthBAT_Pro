//
//  BATRongCloudManager.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRongCloudManager.h"
#import "BATAppDelegate+BATResetLogin.h"
#import "BATNotificationMessage.h"

#import "BATPerson.h"
#import "BATRongCloudUserModel.h"

@implementation BATRongCloudManager

singletonImplemention(BATRongCloudManager)

#pragma mark - 登录/注销
- (void)bat_loginRongCloudWithToken:(NSString *)rongCloudToken
                            success:(void(^)(NSString *userId))success
                              error:(void(^)(RCConnectErrorCode status))error
                     tokenIncorrect:(void(^)(void))tokenIncorrect {
    
    [[RCIM sharedRCIM] connectWithToken:rongCloudToken success:^(NSString *userId) {
        DDLogDebug(@"融云 登陆成功。当前登录的用户ID：%@", userId);
        
        //创建用户信息字典
        [self getRongCloudUserFromFile];
        
        //登录成功设置监听
        //连接状态监听
        [[RCIM sharedRCIM] setConnectionStatusDelegate:[BATRongCloudManager sharedBATRongCloudManager]];
        //接收消息监听
        [[RCIM sharedRCIM] setReceiveMessageDelegate:[BATRongCloudManager sharedBATRongCloudManager]];
        //用户信息策略
        [[RCIM sharedRCIM] setUserInfoDataSource:[BATRongCloudManager sharedBATRongCloudManager]];
        //保存当前用户信息
        BATPerson *person = PERSON_INFO;
        RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:person.Data.UserName portrait:person.Data.PhotoPath];
        [[RCIM sharedRCIM] setCurrentUserInfo:currentUserInfo];
        [self.userInfoDic setObject:currentUserInfo forKey:userId];
    
        //设置用户头像为圆形
        [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
        if (success) {
            success(userId);
        }
    } error:^(RCConnectErrorCode status) {
        DDLogDebug(@"登陆的错误码为:%ld", (long)status);
        if (error) {
            error(status);
        }
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        DDLogDebug(@"token错误");
        if (tokenIncorrect) {
            tokenIncorrect();
        }
    }];
}

- (void)bat_loginOutRongCloud {
    
    [[RCIM sharedRCIM] logout];
}

- (BOOL)bat_getRongCloudStatus {
    
    if ([[RCIM sharedRCIM] getConnectionStatus] == ConnectionStatus_Connected) {
        
        return YES;
    }
    else {
        
        return NO;
    }
}

- (void)bat_rongCloudRegistDeviceToken:(NSData *)deviceToken {
    
    NSString *token =
    [[[[deviceToken description]
       stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString:@" "withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

#pragma mark - 用户状态
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    switch (status) {
        case ConnectionStatus_UNKNOWN:
        {
            
        }
            break;
        case ConnectionStatus_Connected:
        {
            //连接中
        }
            break;
        case ConnectionStatus_NETWORK_UNAVAILABLE:
        {
            
        }
            break;
        case ConnectionStatus_AIRPLANE_MODE:
        {
            
        }
            break;
        case ConnectionStatus_Cellular_2G:
        {
            
        }
            break;
        case ConnectionStatus_Cellular_3G_4G:
        {
            
        }
            break;
        case ConnectionStatus_WIFI:
        {
            
        }
            break;
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:
        {
            //踢下线

            [self showAlertWithMessage:@"您的帐号在另一台设备登录!"];

        }
            break;
        case ConnectionStatus_LOGIN_ON_WEB:
        {
            
        }
            break;
        case ConnectionStatus_SERVER_INVALID:
        {
            
        }
            break;
        case ConnectionStatus_VALIDATE_INVALID:
        {
            
        }
            break;
        case ConnectionStatus_Connecting:
        {
            
        }
            break;
        case ConnectionStatus_Unconnected:
        {
            
        }
            break;
        case ConnectionStatus_SignUp:
        {
            
        }
            break;
        case ConnectionStatus_TOKEN_INCORRECT:
        {
            
        }
            break;
        case ConnectionStatus_DISCONN_EXCEPTION:
        {
            
        }
            break;
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    
    //清空极光推送别名
    BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate bat_logout];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    UIWindow *mainWindow = MAIN_WINDOW;
    [mainWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 发送消息
- (void)bat_sendRongCloudMessageWithType:(RCConversationType)type
                                targetId:(NSString *)targetId
                                 content:(RCMessageContent *)content
                             pushContent:(NSString *)pushContent
                                pushData:(NSString *)pushData
                                 success:(void(^)(long messageId))success
                                   error:(void(^)(RCErrorCode nErrorCode, long messageId))error {
    
    [[RCIM sharedRCIM] sendMessage:type targetId:targetId content:content pushContent:pushContent pushData:pushData success:^(long messageId) {
        if (success) {
            success(messageId);
        }
    } error:^(RCErrorCode nErrorCode, long messageId) {
        if (error) {
            error(nErrorCode,messageId);
        }
    }];
}

#pragma mark - 接收消息监听
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left {
    
    
    //根据发送者ID，写入融云用户数据
    if (![self.userInfoDic.allKeys containsObject:message.senderUserId]) {
        //没有该用户信息，获取并写入
        
        [self bat_userInfoRequestWithAccountID:message.senderUserId];
    }
    
    
    if ([message.content isMemberOfClass:[BATNotificationMessage class]]) {
        BATNotificationMessage *batMsg = (BATNotificationMessage *)message.content;
        BATDoctorStudioTextImageStatus actionType = [batMsg.actionStatus integerValue];
        
        switch (actionType) {
            case batDoctorStudioTextImageStatus_DoctorAskOver:
            {
                //医生请求结束
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否结束问诊？" message:@"感谢您的信任和支持，如结束咨询，请对我的服务进行评价。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续咨询" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //取消结束
                    BATNotificationMessage *messageContent = [BATNotificationMessage messageWithActionStatus:[NSString stringWithFormat:@"%ld",(long)batDoctorStudioTextImageStatus_PatientCancelOver] orderNo:batMsg.orderNo targetId:batMsg.targetId doctorName:batMsg.doctorName patientName:batMsg.patientName];
                                                                
                    [[BATRongCloudManager sharedBATRongCloudManager] bat_sendRongCloudMessageWithType:ConversationType_GROUP targetId:batMsg.targetId content:messageContent pushContent:[NSString stringWithFormat:@"患者%@请求继续咨询",batMsg.patientName] pushData:nil success:^(long messageId) {
   
                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                    
                    if (self.continueIMBlock) {
                        self.continueIMBlock(batMsg.orderNo);
                    }
                }];
                
                UIAlertAction *endAction = [UIAlertAction actionWithTitle:@"结束咨询" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    BATNotificationMessage *messageContent = [BATNotificationMessage messageWithActionStatus:[NSString stringWithFormat:@"%ld",(long)batDoctorStudioTextImageStatus_PatientAgreeOver] orderNo:batMsg.orderNo targetId:batMsg.targetId doctorName:batMsg.doctorName patientName:batMsg.patientName];
                    
                    [[BATRongCloudManager sharedBATRongCloudManager] bat_sendRongCloudMessageWithType:ConversationType_GROUP targetId:batMsg.targetId content:messageContent pushContent:[NSString stringWithFormat:@"患者%@同意结束咨询",batMsg.patientName] pushData:nil success:^(long messageId) {

                    } error:^(RCErrorCode nErrorCode, long messageId) {
                        
                    }];
                    
                    if (self.endIMBlock) {
                        self.endIMBlock(batMsg.orderNo);
                    }
                    else {
                        //如果block为空，即不在聊天会话界面里，调用接口结束订单
                        [HTTPTool requestWithURLString:@"/api/order/CloseConsultOrder" parameters:@{@"orderNo":batMsg.orderNo} type:kGET success:nil failure:nil];
                    }
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:endAction];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    UIWindow *window = MAIN_WINDOW;
                    [window.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
                break;
            case batDoctorStudioTextImageStatus_PatientAgreeOver:
            {
                //患者同意结束
            }
                break;
            case batDoctorStudioTextImageStatus_PatientCancelOver:
            {
                //患者取消结束
            }
            case batDoctorStudioTextImageStatus_PatientComplain:
            {
                //患者投诉消息
            }
                break;
        }
        
    }
    
    DDLogDebug(@"还剩余的未接收的消息数：%d", left);
}

- (void)bat_userInfoRequestWithAccountID:(NSString *)accountID {
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Patient/Info/%@",accountID] parameters:nil type:kGET success:^(id responseObject) {
        
        BATRongCloudUserModel *model = [BATRongCloudUserModel mj_objectWithKeyValues:responseObject];
        
        [self bat_saveRongCloudUserInfoWithUserId:accountID name:model.Data.UserName portraitUri:model.Data.PhotoPath];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 用户信息策略
/*!
 获取用户信息
 
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    
    if ([self.userInfoDic.allKeys containsObject:userId]) {
        RCUserInfo *userInfo = self.userInfoDic[userId];
        if (completion) {
            completion(userInfo);
        }
    }
}

- (void)bat_saveRongCloudUserInfoWithUserId:(NSString *)userId
                                       name:(NSString *)name
                                portraitUri:(NSString *)portraitUri {
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portraitUri];
    [self.userInfoDic setObject:userInfo forKey:userId];
}

- (RCUserInfo *)bat_getRongCloudUserInfo {
    
    
    return [[RCIM sharedRCIM] currentUserInfo];
}

- (BOOL)bat_rongCloudUserWriteToFile {
    
    NSString *areafile = [NSHomeDirectory() stringByAppendingPathComponent:locationRongCloudUserData];

    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:[NSDictionary dictionaryWithDictionary:self.userInfoDic] toFile:areafile];
    
    return isSuccess;
}

- (void)getRongCloudUserFromFile {

    NSString *areafile = [NSHomeDirectory() stringByAppendingPathComponent:locationRongCloudUserData];

    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:areafile];

    self.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (!self.userInfoDic) {
        self.userInfoDic = [NSMutableDictionary dictionary];
    }
}

@end
