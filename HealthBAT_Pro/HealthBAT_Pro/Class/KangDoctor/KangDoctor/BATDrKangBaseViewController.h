//
//  BATDrKangBaseViewController.h
//  HealthBAT_Pro
//
//  Created by mac on 2018/3/19.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 康博士右上角按钮枚举
 
 - BATDrKangRightBarButtonHistory: 历史智能问诊
 - BATDrKangRightBarButtonEvaluation: 健康评估
 - BATDrKangRightBarButtonHealthThreeSecond: 健康3秒钟
 */
typedef NS_ENUM(NSInteger, BATDrKangRightBarButtonItems) {
    
    BATDrKangRightBarButtonHistory = 2000,
    BATDrKangRightBarButtonEvaluation = 2001,
    BATDrKangRightBarButtonHealthThreeSecond = 2002,
};

/**
 康博士当前页面状况
 
 - BATDrKangViewStationChat: 聊天
 - BATDrKangViewStationWelcome: 欢迎
 - BATDrKangViewStationAskView: 特殊问题页面
 */
typedef NS_ENUM(NSInteger, BATDrKangViewStation) {
    
    BATDrKangViewStationChat = 1000,
    BATDrKangViewStationWelcome = 1001,
    BATDrKangViewStationAskView = 1002,
};

@interface BATDrKangBaseViewController : UIViewController

//必要参数
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *userDeviceId;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;
@property (nonatomic,strong) NSString *requestSource;

@property (nonatomic,copy) void(^rightBarActionBlock)(NSInteger tag);

//可选参数
@property (nonatomic,strong) NSString *avatarUrl;


/**
 点击了超链接，根据超链接的参数处理

 @param flag 处理标识
 @param dic  超链接参数
 */
- (void)handleFlag:(NSString *)flag allPara:(NSDictionary *)allPara;

//执行order
/**
 执行order

 @param order order命令
 */
- (void)executiveOrder:(NSString *)order;


/**
 发送信息

 @param content 内容
 @param isSound 是否语音输入
 */
- (void)sendTextRequestWithContent:(NSString *)content isSound:(BOOL)isSound;


/**
 发送信息

 @param parameters 参数
 @param isSound 是否语音输入
 */
- (void)sendTextRequestWithParameters:(NSDictionary *)parameters isSound:(BOOL)isSound;


/**
 点击事件

 @param url url
 */
- (void)eventRequestWithURL:(NSString *)url;


/**
 点击展开详情

 @param url url
 */
- (void)detailRequestWithURL:(NSString *)url;


/**
 欢迎语
 */
- (void)introduceRequest;


/**
 展开详情接口处理

 @param responseObject responseObject
 */
- (void)expandDeitalViewWithResponseObject:(id)responseObject;


/**
 新接口处理

 @param responseObject responseObject
 @param isSound 是否语音输入
 */
- (void)handleNewResponseObject:(id)responseObject isSound:(BOOL)isSound;


/**
 旧接口处理

 @param responseObject responseObject
 */
- (void)handleResponseObject:(id)responseObject;
@end

