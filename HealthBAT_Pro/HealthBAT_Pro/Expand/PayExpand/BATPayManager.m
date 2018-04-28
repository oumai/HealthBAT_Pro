//
//  BATPayManager.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPayManager.h"
#import "SVProgressHUD.h"
#import "BATWeChatPayOrderInfoModel.h"
#import "BATAlipayOrderInfoModel.h"
#import "BATKMPayOrderInfoModel.h"
#import "SVProgressHUD.h"

@interface BATPayManager ()

@property (nonatomic,strong) NSString *orderNo;

@end

@implementation BATPayManager

+ (BATPayManager *)shareManager
{
    static BATPayManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATPayManager alloc] init];
        
        //康美支付 用于注册tmd的没安装app时的支付结果监听
        [BATKMPayHandle shareKMPayHandle];
    });
    return instance;
}

#pragma mark - private
//url编码
- (NSString *)urlInURLEncoding:(NSString *)str
{
    
    NSString *encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedUrl;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *bundleid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    
    if ([url.host isEqualToString:@"safepay"]) {
         //支付宝
        [[BATAlipayHandle shareAlipayHandle] handleAliPay:url];
    } else if ([url.scheme isEqualToString:bundleid]) {
        //康美钱包
        [KMTPayApi handleOpenURL:url delegate:[BATKMPayHandle shareKMPayHandle]];
    } else {
        //微信
        return [WXApi handleOpenURL:url delegate:[BATWeChatPayHandle shareWeChatPayHandle]];
    }
    
    return YES;
}

- (void)pay:(NSDictionary *)orderInfo payType:(BATPayType)payType orderNo:(NSString *)orderNo complete:(PayCompleteBlock)payCompleteBlock
{
    [SVProgressHUD dismiss];
    _orderNo = orderNo;
    self.payCompleteBlock = payCompleteBlock;
    if (payType == BATPayType_Alipay) {
        //支付宝
        [self requestAlipay:orderInfo];
        
    } else if (payType == BATPayType_WeChat) {
        //微信
        [self requestWeChatPay:orderInfo];
        
    } else if (payType == BATPayType_KMPay) {
        //康美钱包
        [self requestKMPay:orderInfo];
        
    } else if (payType == BATPayType_IAP) {
        //iap
        [self requestIAP:orderInfo];
    }
}

#pragma mark - 发起支付宝支付请求
- (void)requestAlipay:(NSDictionary *)orderInfo
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    BATAlipayOrderInfoModel *orderInfoModel = [BATAlipayOrderInfoModel mj_objectWithKeyValues:orderInfo];
    
    if (orderInfoModel.Data.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    [[AlipaySDK defaultService] payOrder:orderInfoModel.Data fromScheme:identifier callback:^(NSDictionary *resultDic) {
        [[BATAlipayHandle shareAlipayHandle] handleResult:resultDic];
    }];
}

#pragma mark - 发起微信支付请求
- (void)requestWeChatPay:(NSDictionary *)orderInfo
{
    
    BATWeChatPayOrderInfoModel *orderInfoModel = [BATWeChatPayOrderInfoModel mj_objectWithKeyValues:orderInfo];
    
    if (orderInfoModel.Data.appid.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.partnerId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.prepay_id.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.package.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.nonce_str.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.timeStamp.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.sign.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }

    PayReq *request = [[PayReq alloc] init];
    request.openID = orderInfoModel.Data.appid;
    request.partnerId = orderInfoModel.Data.partnerId;
    request.prepayId = orderInfoModel.Data.prepay_id;
    request.package = orderInfoModel.Data.package;
    request.nonceStr = orderInfoModel.Data.nonce_str;
    request.timeStamp = [orderInfoModel.Data.timeStamp intValue];
    request.sign = orderInfoModel.Data.sign;
    [WXApi sendReq:request];
}


#pragma mark - 发起康美钱包支付请求
- (void)requestKMPay:(NSDictionary *)orderInfo
{
    BATKMPayOrderInfoModel *orderInfoModel = [BATKMPayOrderInfoModel mj_objectWithKeyValues:orderInfo];
    
    if (orderInfoModel.Data.partner.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.notifyUrl.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.returnUrl.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.outTradeNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.totalAmount.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.sellerEmail.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.subject.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.body.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.timestamp.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    if (orderInfoModel.Data.sign.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付参数错误"];
        return;
    }
    
    
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                         orderInfoModel.Data.body,@"body",
    //                         orderInfoModel.Data.notifyUrl,@"notifyUrl",
    //                         orderInfoModel.Data.returnUrl,@"returnUrl",
    //                         orderInfoModel.Data.partner,@"partner",
    //                         @"UTF-8",@"inputCharset",
    //                         orderInfoModel.Data.outTradeNo,@"outTradeNo",
    //                         orderInfoModel.Data.sellerEmail,@"sellerEmail",
    //                         orderInfoModel.Data.subject,@"subject",
    //                         orderInfoModel.Data.timestamp,@"timestamp",
    //                         orderInfoModel.Data.totalAmount,@"totalAmount",
    //                         nil];
    //
    //    NSString *pstr = [self stringFromDictionaryParameters:dic];
    //
    //    HBRSAHandler *handler = [HBRSAHandler new];
    //    [handler importKeyWithType:KeyTypePrivate andkeyString:@"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBALac3bEa4Q6bujMPtG339CuIP6Dc6/tTR60nyz0LOdlW8Bfs428sLOdwjcU7relxfBUVCTezZ2Drg4M6l1IDxqK+wdy9VkTTAalY8B/CDkA1DOTupY9cI/u4TXky6InPE9aTUds9TKh66EHUsKHmE/p5jM9xb06q+CQtvMZluWelAgMBAAECgYEAiCyr6NDZeRJJpKAWdVbMntXIVQXJd64fqhEdrpS7e8Yn3j+JTjLL/X5iSez6ADXfSL1aFU5UTeLyPB6qDr/AFAPHB+hrhd7ZDFWJM3bD2p3HreYuRwpT9+4STi3VJMW9GNPqcbw6wXMW/8f7t1lfPoR3JrrmC2p5K2ihHXedOqECQQDd1Ax9LENRkef1aLxX4JI3Ij/cr5HAnLxcopyPDlUR8wtx4JqW2U/HNp+s5Xx6pg2EZFTnIggN1uCCITUQWUApAkEA0r5TKyqzeBDQ3WZfF+YrfhR9aBkncUgSjgrw7AS6KeQlndr5LPIyyGdYRQPqur/jurS014/70vtMQx3xWOxrHQJBALgHzXyjFg47/7YG+AnnkyYOUfDh7wdegJ5RgZTlDQphGiOVdGqlSpw44utrT4Po8tnc6tr9zrS8iXEr33v6r1ECQQC8qI8xrJdfW8Zu/Q8SCQZUZylhAGuz2K5rpFXLI+w4Rjp6lyXL28Ikb4ewuPHwXooSgWUHOKlaVYcO6oY9cd/tAkEAyA6zr5rBIgnx7oVkoWPFCCdEy7HyoyuPQs/cNHXpfXqQYnjHFV7fBwFEBO80NHAfEf5ZXZPWByWNDv993gvTnQ=="];
    //
    //
    //    NSString *sign = [handler signString:pstr];
    
    KMTPayReq *kmtPayReq = [[KMTPayReq alloc]init];
    
    kmtPayReq.partner = orderInfoModel.Data.partner;
    kmtPayReq.notifyUrl = orderInfoModel.Data.notifyUrl;
    kmtPayReq.returnUrl = orderInfoModel.Data.returnUrl;
    kmtPayReq.outTradeNo = orderInfoModel.Data.outTradeNo;
    kmtPayReq.totalAmount = orderInfoModel.Data.totalAmount;
    kmtPayReq.sellerEmail = orderInfoModel.Data.sellerEmail;
    kmtPayReq.subject = orderInfoModel.Data.subject;
    kmtPayReq.body = orderInfoModel.Data.body;
    kmtPayReq.timestamp = orderInfoModel.Data.timestamp;
    kmtPayReq.rsaSign = [self urlInURLEncoding:orderInfoModel.Data.sign];
    
    [KMTPayApi sendReq:kmtPayReq];

}

#pragma mark - iap支付
- (void)requestIAP:(NSDictionary *)orderInfo
{
    NSString *productIdentifier = [orderInfo objectForKey:@"productIdentifier"];
    
    [[BATIAPManager shareManager] pay:productIdentifier orderNo:_orderNo];
}

#pragma mark - 验证支付
- (void)payCompleteVerification:(BOOL)flag
{
    
    if (self.payCompleteBlock) {
        self.payCompleteBlock(flag);
    }
    
//    [SVProgressHUD showWithStatus:@"正在验证支付结果..."];
//    [HTTPTool requestWithURLString:@"/api/NetworkMedical/PayComplete" parameters:@{@"orderNo":_orderNo} type:kGET success:^(id responseObject) {
////        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//        
//        if (self.payCompleteBlock) {
//            self.payCompleteBlock(YES);
//        }
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"验证支付失败"];
//        
//        if (self.payCompleteBlock) {
//            self.payCompleteBlock(NO);
//        }
//    }];
}

@end
