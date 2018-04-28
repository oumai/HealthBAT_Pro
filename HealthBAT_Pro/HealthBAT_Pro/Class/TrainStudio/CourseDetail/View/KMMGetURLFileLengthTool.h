//
//  KMMGetURLFileLengthTool.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMMGetURLFileLengthTool : NSObject <NSURLConnectionDataDelegate>

typedef void(^FileLength)(long long length, NSError *error);

@property (nonatomic, strong) FileLength block;

typedef void(^netSate)(NSString *netSateString);

@property (nonatomic, strong) netSate stateBlock;

+ (instancetype)shareInstance;

/**
 *  通过url获得网络的文件的大小 返回byte
 *
 *  @param url 网络url
 *
 *  @block 文件的大小 byte
 */
- (void)getUrlFileLength:(NSString *)url withResultBlock:(FileLength)block;

- (void)getNetSateWithResultBlock:(netSate)netBlock;

@end
