//
//  BATPayManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h" //微信支付
#import <AlipaySDK/AlipaySDK.h> //支付宝支付
#import "KMTPayApi.h" //康美支付
#import "BATIAPManager.h" //iap支付

#import "BATKMPayHandle.h" //康美支付支付结果处理
#import "BATAlipayHandle.h" //支付宝支付支付结果处理
#import "BATWeChatPayHandle.h" //微信支付支付结果处理

/**
 *  支付方式
 */
typedef NS_ENUM(NSInteger, BATPayType) {
    /**
     *  支付宝
     */
    BATPayType_Alipay = 0,
    /**
     *  微信
     */
    BATPayType_WeChat,
    /**
     *  康美钱包
     */
    BATPayType_KMPay,
    /**
     *  苹果内购iap
     */
    BATPayType_IAP
};

typedef void(^PayCompleteBlock)(BOOL isSuccess);

@interface BATPayManager : NSObject

/**
 *  支付完成验证支付后的回调
 */
@property (nonatomic,strong) PayCompleteBlock payCompleteBlock;

+ (BATPayManager *)shareManager;

/**
 *  处理支付回调
 *
 *  @param url      URL
 *
 *  @return YES/NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url;


/**
 *  发起支付
 *
 *  @param orderInfo 订单信息
 *  @param payType   支付方式
 *  @param orderNo   订单编号
 *  @param payCompleteBlock   回调
 */
- (void)pay:(NSDictionary *)orderInfo payType:(BATPayType)payType orderNo:(NSString *)orderNo complete:(PayCompleteBlock)payCompleteBlock;

/**
 *  第三方平台支付成功后，向服务器发起验证订单
 */
- (void)payCompleteVerification:(BOOL)flag;


@end
