//
//  BATTIMManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//TIM
#import <ImSDK/ImSDK.h>
//#import "IMAMsg.h"

typedef NS_ENUM(int, BATChatType) {
    BATChatType_Audio,//音频
    BATChatType_Video,//视频
    BATChatType_Message,//文本聊天
};

//状态 0=未就诊,1=候诊中,2=就诊中,3=已就诊,4=呼叫中,5=离开中
typedef NS_ENUM(int, BATChatRoomState) {
//    BATChatRoomState_Invalid = -1,//状态无效
    BATChatRoomState_NoVisit = 0,//未就诊
    BATChatRoomState_Waiting = 1,//候诊中
    BATChatRoomState_Consulting = 2,//就诊中
    BATChatRoomState_Consulted = 3,//已就诊
    BATChatRoomState_Calling = 4,//呼叫中
    BATChatRoomState_Leaving = 5,//离开中
//    BATChatRoomState_CutConnection = 6,//断开连接
};

typedef NS_ENUM(int, ActionState) {
    ActionState_UnKnown = -1,
    ActionState_PatientOriginalState,//患者端原始状态

    ActionState_PatientVideoWaiting,//患者视频等待
    ActionState_PatientVideoCanceledCalling,//患者视频取消等待
    ActionState_PatientVideoConsulting,//患者视频会诊中
    ActionState_PatientVideoCalled,//患者视频被呼叫
    ActionState_PatientVideoReject,//患者视频拒绝接听
    ActionState_PatientVideoAnswer,//患者端视频接听
    ActionState_PatientVideoLeaveRoom,//患者退出视频房间

    ActionState_PatientAudioWaiting,//患者音频等待
    ActionState_PatientAudioCanceledCalling,//患者音取消等待
    ActionState_PatientAudioConsulting,//患者音频会诊中
    ActionState_PatientAudioCalled,//患者音频被呼叫
    ActionState_PatientAudioReject,//患者音频拒绝接听
    ActionState_PatientAudioHangupCalling,//患者端挂断音频
    ActionState_PatientAudioAnswer,//患者端音频接听
    ActionState_PatientAudioLeaveRoom,//患者退出音频房间

    ActionState_PatientOther,



    ActionState_DoctorOriginalState,//医生端原始状态

    ActionState_DoctorVideoCalling,//医生视频呼叫
    ActionState_DoctorVideoConsulting,//医生视频会诊中
    ActionState_DoctorVideoCanceledCalling,//医生取消视频呼叫

    ActionState_DoctorAudioCalling,//医生音频呼叫
    ActionState_DoctorAudioConsulting,//医生音频会诊中
    ActionState_DoctorAudioCanceledCalling,//医生取消音频呼叫
    ActionState_DoctorAudioHangupCalling,//医生端挂断音频呼叫

    ActionState_DoctorOther,
    
};

@interface BATTIMManager : NSObject<TIMMessageListener,TIMUserStatusListener>

/**
 *  当前会话
 */
@property (nonatomic,strong) TIMConversation * currentConversation;

/**
 *  单利
 *
 *  @return 单利
 */
+ (BATTIMManager *)sharedBATTIM;

#pragma mark - 登入、退出操作
/**
 *  登录tim
 */
- (void)bat_loginTIM;

/**
 *  退出TIM
 */
- (void)bat_loginOutTIM;

/**
 *  获取当前用户
 */
- (void)bat_getLoginUser;

/**
 *  获取登陆状态
 *
 *  @return 是否登陆
 */
- (BOOL)bat_getLoginStatus;
#pragma mark - 收发消息

/**
 *  获取当前对话
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver C2C 为对方帐号identifier， GROUP 为群组Id
 *
 *  @return 会话对象
 */
- (TIMConversation *)bat_currentConversationWithType:(TIMConversationType)type receiver:(NSString *)receiver;
/**
 *  发送消息
 *
 *  @param message 消息
 *  @param success 成功
 *  @param failure 失败
 */
- (void)bat_sendMessage:(TIMMessage *)message success:(void (^)(void))success failure:(void (^)(int code, NSString *msg))failure;
/**
 *  监听收到消息的回调
 *
 *  @param listener 代理
 */
- (void)bat_MessageListener:(id<TIMMessageListener>)listener;

/**
 *  移除监听消息回调，dealloc中执行
 *
 *  @param listener 代理
 */
- (void)bat_removeMessagelistener:(id<TIMMessageListener>)listener;

#pragma mark - 加群操作
/**
 *  加入群组
 *
 *  @param groupID 群组id
 *  @param msg     加入理由
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)bat_joinGroup:(NSString *)groupID msg:(NSString*)msg success:(void (^)(void))success failure:(void (^)(void))failure;

/**
 *  退出群组
 *
 *  @param groupID 群组id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)bat_quitGroup:(NSString *)groupID success:(void (^)(void))success failure:(void (^)(void))failure;


//#pragma mark - 接收新消息
///**
// *  解析当前候诊房间状态
// *
// *  @param chatType              会话烈性
// *  @param chatRoomState         当前收到房间状态
// *  @param previousChatRoomState 之前房间状态
// *
// *  @return
// */
//+ (ActionState)parseActionStateWithChatType:(BATChatType)chatType
//                              chatRoomState:(BATChatRoomState)chatRoomState
//                      previousChatRoomState:(BATChatRoomState)previousChatRoomState;
//
//- (void)bat_onNewMessage;
//
//- (void)listenWithIMAUser:(IMAUser *)user;


@end
