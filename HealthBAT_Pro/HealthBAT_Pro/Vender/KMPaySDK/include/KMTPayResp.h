//
//  KMTPayResp.h
//  KMTPayApi
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>

//使用康美钱包支付时错误码
typedef NS_ENUM(NSInteger, KMTPayErrorCode) {
    KMTPayErrCodeUserCancel     = 0,    /**用户点击取消并返回 */
    KMTPaySuccess               = 1,   /**交易成功*/
    KMTPayErrCodeSentFail       = 2,   /**交易失败*/
    KMTPayProcessing            = 3,   /**交易处理中*/
};


/*＊
 *  该类为康美钱包终端SDK响应类
 */
@interface KMTPayResp : NSObject
// 错误码
@property (nonatomic, assign) KMTPayErrorCode errorCode;
// 错误提示字符串
@property (nonatomic, retain) NSString *errorMessage;

@end
