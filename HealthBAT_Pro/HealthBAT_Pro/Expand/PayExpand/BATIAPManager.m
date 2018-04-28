//
//  BATIAPManager.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/11.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"
#import "BATPayManager.h"

@interface BATIAPManager () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy) NSString *productIdentifier;

@property (nonatomic,copy) NSString *orderNo;

@end

@implementation BATIAPManager

+ (BATIAPManager *)shareManager
{
    static BATIAPManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATIAPManager alloc] init];
    });
    return instance;
}

#pragma mark - public
- (void)addTransactionObserver
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)removeTransactionObserver
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)pay:(NSString *)productIdentifier orderNo:(NSString *)orderNo
{
    _productIdentifier = nil;
    _orderNo = nil;
    if ([SKPaymentQueue canMakePayments]) {
        //判断app是否允许iap
        _productIdentifier = productIdentifier;
        _orderNo = orderNo;
        [self requestProduct:productIdentifier];
    } else {
        [SVProgressHUD showErrorWithStatus:@"APP不允许进行支付"];
    }
}

/**
 根据产品ID请求商品

 @param productIdentifier 产品ID
 */
- (void)requestProduct:(NSString *)productIdentifier
{
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    
    NSSet *set = [NSSet setWithArray:product];
    
    //初始化请求
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    //开始请求
    [request start];
    
    [SVProgressHUD show];
}

/**
 验证遗漏的票据
 */
- (void)checkUnchekReceipt
{
    NSArray *array = [self getUncheckReceipt];
    
    if (array.count == 0 || array == nil) {
        return;
    }
    
    for (NSDictionary *param in array) {
        [self varifyPay:param];
    }
}

#pragma mark - private

/**
 完成交易

 @param tran 支付交易
 */
- (void)completeTransaction:(SKPaymentTransaction *)tran
{
    [[SKPaymentQueue defaultQueue] finishTransaction:tran];
}

/**
 组拼请求参数

 @param receipt 待验证票据
 @return 组拼好的数据字典
 */
- (NSDictionary *)unCheckReceipt:(NSData *)receipt
{
    NSString *encodingReceipt = [receipt base64EncodedStringWithOptions:0];
    
    if (encodingReceipt == nil) {
        return nil;
    }
    
    if (_orderNo == nil) {
        return nil;
    }
    
    NSDictionary *unCheckReceiptDic = @{@"orderNo":_orderNo,@"receiptData":encodingReceipt};
    
    return unCheckReceiptDic;
}

/**
 获取待验证的票据数组

 @return 待验证的票据数组
 */
- (NSArray *)getUncheckReceipt
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    if ([userDefaults objectForKey:@"UncheckReceipt"] != nil) {
        [array addObjectsFromArray:[userDefaults objectForKey:@"UncheckReceipt"]];
    }
    return array;
}

/**
 保存票据

 @param receipt 票据
 */
- (void)saveReceipt:(NSData *)receipt
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    if ([userDefaults objectForKey:@"UncheckReceipt"] != nil) {
        [array addObjectsFromArray:[userDefaults objectForKey:@"UncheckReceipt"]];
    }
    
    [array addObject:[self unCheckReceipt:receipt]];
    
    [userDefaults setObject:array forKey:@"UncheckReceipt"];
    [userDefaults synchronize];
}

/**
 删除验证成功的票据

 @param orderNo 订单号
 */
- (void)removeReceipt:(NSString *)orderNo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    if ([userDefaults objectForKey:@"UncheckReceipt"] != nil) {
        [array addObjectsFromArray:[userDefaults objectForKey:@"UncheckReceipt"]];
    }
    
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"orderNo"] isEqualToString:orderNo]) {
            [array removeObject:dic];
            break;
        }
    }
    
    [userDefaults setObject:array forKey:@"UncheckReceipt"];
    [userDefaults synchronize];
}

/**
 验证票据

 @param receipt 票据
 */
- (void)varifyPay:(NSDictionary *)param
{
    
    NSString *pOrderNo = [param objectForKey:@"orderNo"];
    
    [HTTPTool requestWithURLString:@"/api/VIPPay/IapPayVerify" parameters:param type:kPOST success:^(id responseObject) {
        
        DDLogDebug(@"xxxx %@",responseObject);
        
        //验证成功
        [[BATPayManager shareManager] payCompleteVerification:YES];
        
//        NSString *orderNo = [responseObject objectForKey:@"Data"];
        
//        if (![pOrderNo isEqualToString:@""]) {
//            [self removeReceipt:pOrderNo];
//            [[BATPayManager shareManager] payCompleteVerification];
//        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    [self removeReceipt:pOrderNo];

}

#pragma mark - delegate
#pragma mark - SKProductsRequestDelegate
//请求商品成功
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    if ([product count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有商品"];
        return;
    }
    
    for (SKProduct *pro in product) {
        
        DDLogDebug(@"商品描述 %@", [pro description]);
        DDLogDebug(@"商品标题 %@", [pro localizedTitle]);
        DDLogDebug(@"商品本地描述 %@", [pro localizedDescription]);
        DDLogDebug(@"商品价格 %@", [pro price]);
        DDLogDebug(@"商品ID %@", [pro productIdentifier]);
        
        if ([pro.productIdentifier isEqualToString:_productIdentifier]) {
            //发起购买
            SKPayment *payment = [SKPayment paymentWithProduct:pro];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
    }
    
}

//请求商品失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

//请求商品信息结束
- (void)requestDidFinish:(SKRequest *)request
{
    DDLogDebug(@"请求商品信息结束");
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                [SVProgressHUD dismiss];
                DDLogDebug(@"交易完成");
                //这里发起服务器校验
                //获取票据
                
                NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];

                NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
            
                //保存票据到本地
                [self saveReceipt:receipt];

                //想服务器请求验证票据
                [self varifyPay:[self unCheckReceipt:receipt]];

                //完成交易
                [self completeTransaction:tran];
            }

                break;
            case SKPaymentTransactionStatePurchasing:
                DDLogDebug(@"商品添加进列表");
                [SVProgressHUD show];
                break;
            case SKPaymentTransactionStateRestored:
                DDLogDebug(@"已经购买过商品");
                [SVProgressHUD dismiss];
                [[BATPayManager shareManager] payCompleteVerification:NO];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                DDLogDebug(@"交易失败");
                [SVProgressHUD dismiss];
                [[BATPayManager shareManager] payCompleteVerification:NO];
                [self completeTransaction:tran];
                break;
            default:
                break;
        }
    }
}

@end
