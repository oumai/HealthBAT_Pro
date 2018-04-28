//
//  KMMGetURLFileLengthTool.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMGetURLFileLengthTool.h"

@implementation KMMGetURLFileLengthTool

+ (instancetype)shareInstance {

    static KMMGetURLFileLengthTool *tool;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[KMMGetURLFileLengthTool alloc]init];
    });
    return tool;
}

- (void)getNetSateWithResultBlock:(netSate)netBlock {
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            NSLog(@"未知网络");
            break;
            
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            if (netBlock) {
                netBlock(@"NoNet");
            }
            NSLog(@"没有网络(断网)");
            break;
            
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            if (netBlock) {
                netBlock(@"phoneNet");
            }
            NSLog(@"手机自带网络");
            break;
            
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            if (netBlock) {
                netBlock(@"WIFI");
            }
            NSLog(@"WIFI");
            break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];

}

/**
 *  通过url获得网络的文件的大小 返回byte
 *
 *  @param url 网络url
 *
 *  @block 文件的大小 byte
 */
- (void)getUrlFileLength:(NSString *)url withResultBlock:(FileLength)block
{
    _block = block;
    NSMutableURLRequest *mURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [mURLRequest setHTTPMethod:@"HEAD"];
    mURLRequest.timeoutInterval = 5.0;
    NSURLConnection *URLConnection = [NSURLConnection connectionWithRequest:mURLRequest delegate:self];
    [URLConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
    NSNumber *length = [dict objectForKey:@"Content-Length"];
    [connection cancel];
    if (_block) {
        _block([length longLongValue], nil);    // length单位是byte，除以1000后是KB（文件的大小计算好像都是1000，而不是1024），
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"获取文件大小失败：%@",error);
    if (_block) {
        _block(0, error);
    }
    [connection cancel];
}

@end
