//
//  BATNotificationMacro.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATNotificationMacro_h
#define BATNotificationMacro_h

#pragma mark - 健康圈我的关注刷新通知
#define BATRefreshDynamicListNotification @"BATRefreshDynamicListNotification"

#pragma mark 刷新关注状态
#define BATRefreshFollowStateNotification @"refreshFollowStateNotification"

#pragma mark 刷新群组的加入状态
#define BATRefreshGroupJoinStateNotification @"refreshGroupJoinStateNotification"

#pragma mark 刷新我加入的群组列表
#define BATRefreshGroupListNotification @"refreshGroupListNotification"

#pragma mark 刷新群组公告
#define BATRefreshGroupAccouncementNotification @"refreshGroupAccouncementNotification"

#pragma mark 刷新发现数据
#define BATRefreshFindDataNotification @"BATRefreshFindDataNotification"

#pragma mark 医生结束服务
#define BATENDSEVERICE  @"ENDSEVERICE"

#pragma mark 无网络时刷新在线学习界面
#define BATRefreshOnlineLearningInterfaceNotification @"BATRefreshOnlineLearningInterfaceNotification"

#pragma mark 在课程评论后或者收藏后刷新对应Model
#define BATRefreshIndexPathModelNotification @"BATRefreshIndexPathModelNotification"

#pragma mark 饮食指导查看详情界面删除后刷新通知
#define BATDiteGuideDetailsDeleteNotification @"BATDiteGuideDetailsDeleteNotification"

#pragma mark 饮食指南发布发布
#define BATDiteGuideEditPushSuccessNotification @"BATDiteGuideEditPushSuccessNotification"

#pragma mark 登录成功获取用户数据成功
#define BATLoginSuccessGetUserInfoSucessNotification @"BATLoginSuccessGetUserInfoSucessNotification"

#pragma mark 用户被强制提下线通知
#define BATuserOnForceOfflineNotification @"BATuserOnForceOfflineNotification"

#pragma mark 饮食指导查看详情界面点赞通知
#define BATDiteGuideDetailsPraiseNotification @"BATDiteGuideDetailsPraiseNotification"

#pragma mark 刷新地址列表
#define BATRefreshAddressNotification @"refreshAddressNotification"

#pragma mark OTC选择收货人
#define BATOTCSelectReceiptUserNotification @"selectReceiptUserNotification"

#pragma mark 点击OTC消息
#define BATClickOTCMessageNotification @"clickOTCMessageNotification"

#pragma mark 刷新资讯详情h5
#define BATReloadWebViewNotification @"reloadWebViewNotification"

//#pragma mark 支付成功进入咨询订单
//#define BATPaySuccessPushToConsultOrderNotification @"BATPaySuccessPushToConsultOrderNotification"

#endif /* BATNotificationMacro_h */
