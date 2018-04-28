//
//  KMTPayApi.h
//  KMTPayDemo
//
//  Created by 123 on 16/2/26.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KMTPayReq.h"
#import "KMTPayResp.h"

@protocol KMTPayApiDelegate <NSObject>

@optional
/** @brief 发送一个sendReq后，收到康美钱包的回应
 *  收到一个来自康美钱包的处理结果。调用一次sendReq后会收到onResp。
 *  @param resp具体的回应内容，见KMTPayResp类的结构
 */
-(void) onResp:(KMTPayResp*)resp;

@end


@interface KMTPayApi : NSObject

/*＊ @brief    判断是否安装了康美钱包
 *
 *   @return  如果安装了康美钱包App返回YES，否则返回NO。
 */
+ (BOOL)isKMTPayInstalled;


/*＊ @brief 获取当前康美钱包SDK的版本号
 *
 *   @return 返回当前康美钱包SDK的版本号
 */
+(NSString *) getKMTPayApiVersion;


/*＊ @brief 获取康美钱包的itunes安装地址
 *
 *   @return 康美钱包的安装地址字符串。
 */
+(NSString *) getKMTPayAppInstallUrl;


/*＊ @brief 处理康美钱包通过URL启动第三方App时传递的数据(数据回调)
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL或者application:openURL:options:中调用。
 * @param url 康美钱包启动第三方应用时传递过来的URL
 * @param delegate  KMTPayApiDelegate对象，用来接收康美钱包触发的消息。
 */
//需要在该方法中触发代理
+(void) handleOpenURL:(NSURL *) url delegate:(id<KMTPayApiDelegate>) delegate;


/** @brief 发送支付请求到康美钱包，等待康美钱包返回onResp
 *
 * 函数调用后，会切换到康美钱包的界面。第三方应用程序等待康美钱包返回onResp。康美钱包在异步处理完成后一定会调用onResp。
 * @return 如果打开了康美钱包App返回YES，否则返回NO。
 */
//第三方应用通过此接口传递生成康美支付预订单所需的信息
+(BOOL) sendReq:(KMTPayReq*)req;


//第三方应用启动康美钱包App时注意:
/*
 *   iOS9后一个App打开另一个App时，必须设置白名单，否则安装了也打不开。
 *   设置方法，在info.plist中添加字段 LSApplicationQueriesSchemes(见添加key.png图片)
 *   <key>LSApplicationQueriesSchemes</key>
 *   <array>
 *   <string>kmtpay</string>
 *   </array>n
 */


@end








