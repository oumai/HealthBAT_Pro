//
//  BATAppDelegate+AgoraCategory.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+AgoraCategory.h"


#import "BATCallViewController.h"
#import "BATChannelModel.h"

@implementation BATAppDelegate (AgoraCategory)

- (void)bat_registerAgora {
    
    [[BATAgoraManager shared] registerAgora];
    [[BATAgoraSignalingManager shared] registerAgoraSignaling];
    
    [BATAgoraSignalingManager shared].delegate = self;
}


#pragma mark - Net
#pragma mark - 获取channelkey
- (void)requestGetChannelKey:(NSString *)chatRoomId complete:(void(^)(BOOL success,NSString *channelKey))complete
{
    [HTTPTool requestWithURLString:@"/api/Doctor/GetChannelKey" parameters:@{@"chatRoomId":chatRoomId} type:kGET success:^(id responseObject) {
        
        
        BATChannelModel *channelModel = [BATChannelModel mj_objectWithKeyValues:responseObject];
        
        if (complete) {
            complete(YES,channelModel.Data);
        }
        
    } failure:^(NSError *error) {
        if (complete) {
            complete(NO,nil);
        }
    }];
}


#pragma mark - BATAgoraSignalingManagerDelegate

- (void)inviteReceived:(NSString *)channel name:(NSString *)name uid:(uint32_t)uid extra:(NSString *)extra
{
    /*
     NSDictionary *dic = @{
     @"Name":doctorDetailModel.Data.DoctorName,
     @"PhotoPath":doctorDetailModel.Data.DoctorPic,
     @"OrderNo":self.orderNo,
     @"HospitalName":doctorDetailModel.Data.HospitalName,
     @"DepartmentName":doctorDetailModel.Data.DepartmentName,
     @"DoctorTitle":doctorDetailModel.Data.DoctorTitle
     };
     */
    //接收到呼叫时
    [self requestGetChannelKey:channel complete:^(BOOL success, NSString *channelKey) {
        
        if (success && channelKey != nil && ![channelKey isEqualToString:@""]) {
            BATCallViewController *callVC = [[BATCallViewController alloc] init];
            
            NSDictionary *dic = [Tools dictionaryWithJsonString:extra];
            if ([dic.allKeys containsObject:@"Name"]) {
                callVC.doctorName = dic[@"Name"];
            }
            if ([dic.allKeys containsObject:@"PhotoPath"]) {
                callVC.doctorPic = dic[@"PhotoPath"];
            }
            if ([dic.allKeys containsObject:@"OrderNo"]) {
                callVC.orderNo = dic[@"OrderNo"];
            }
            if ([dic.allKeys containsObject:@"DepartmentName"]) {
                callVC.departmentName = dic[@"DepartmentName"];
            }
            if ([dic.allKeys containsObject:@"DoctorTitle"]) {
                callVC.doctorTitle = dic[@"DoctorTitle"];
            }
            if ([dic.allKeys containsObject:@"HospitalName"]) {
                callVC.hospitalName = dic[@"HospitalName"];
            }
            
            callVC.callState = BATCallState_Answer;
            callVC.doctorID = name;
            callVC.channelKey = channelKey;
            callVC.roomID = channel;
            
            [self.window.rootViewController presentViewController:callVC animated:YES completion:nil];
            
        }
        
    }];
}

- (void)inviteFailed:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid ecode:(AgoraEcode)ecode extra:(NSString *)extra {
    
    //对方没有接到呼叫
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallNoAnswerNotification" object:nil];
    });
    
    //离开信令频道
    [[BATAgoraSignalingManager shared] channelLeave:channel];
    
    //离开引擎频道
    [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
        
    }];
}
- (void)inviteAcceptedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t )uid extra:(NSString *)extra {
    
    //对方同意呼叫
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallAcceptedNotification" object:nil];
    });
}

- (void)inviteReceivedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t)uid extra:(NSString *)extra
{
    //对方接收到呼叫
    [self requestGetChannelKey:channel complete:^(BOOL success, NSString *channelKey) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallJoinChannelNotification" object:channelKey];
        
    }];
}

- (void)inviteRefusedByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t)uid extra:(NSString *)extra
{
    //对方已拒绝呼叫
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallRefusedByPeerNotification" object:nil];
    
    //离开信令频道
    [[BATAgoraSignalingManager shared] channelLeave:channel];
    
    //离开引擎频道
    [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
        
    }];
    
}

- (void)inviteEndByMyself:(NSString *)channel name:(NSString *)name uid:(uint32_t)uid extra:(NSString *)extra
{
    //自己结束呼叫
    
    //离开信令频道
    [[BATAgoraSignalingManager shared] channelLeave:channel];
    
    //离开引擎频道
    [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
        
    }];
}

- (void)inviteEndByPeer:(NSString *)channel name:(NSString *)name uid:(uint32_t)uid extra:(NSString *)extra
{
    //对方已结束呼叫
    
    if (![[BATAgoraSignalingManager shared].channelID isEqualToString:channel] && [BATAgoraSignalingManager shared].channelID != nil) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BATCallEndByPeerNotification" object:nil];
    
    //离开信令频道
    [[BATAgoraSignalingManager shared] channelLeave:channel];
    
    //离开引擎频道
    [[BATAgoraManager shared] leaveChannel:^(AgoraRtcStats *stat) {
        
    }];
}


@end
