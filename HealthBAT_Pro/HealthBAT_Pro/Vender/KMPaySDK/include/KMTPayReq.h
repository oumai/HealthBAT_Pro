//
//  KMTPayReq.h
//  KMTPayApi
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>

/*＊
 *  该类为SDK生成康美支付预订单模型类
 */
@interface KMTPayReq : NSObject

//商户编号
@property (copy, nonatomic) NSString *partner;
//商户异步回调地址,必须以http://或htpps://开头
@property (copy, nonatomic) NSString *notifyUrl;
//商户同步跳转地址，必须以http://或htpps://开头(选传)
@property (copy, nonatomic) NSString *returnUrl;
//商户订单号
@property (copy, nonatomic) NSString *outTradeNo;
//支付金额
@property (copy, nonatomic) NSString *totalAmount;
//卖方账号
@property (copy, nonatomic) NSString *sellerEmail;
//商品名称
@property (copy, nonatomic) NSString *subject;
//商品描述
@property (copy, nonatomic) NSString *body;
//支付防钓鱼时间戳
@property (copy, nonatomic) NSString *timestamp;
//RSA签名值,需要使用URL编码
@property (copy, nonatomic) NSString *rsaSign;

/*以下参数用于康美电商帐号登陆h5时使用,均选传*/
@property (copy, nonatomic) NSString *kmpayAccount;  //康美钱包帐号
@property (copy, nonatomic) NSString *srcAccount;    //平台帐号
@property (copy, nonatomic) NSString *src;           //平台来源标记


@end
