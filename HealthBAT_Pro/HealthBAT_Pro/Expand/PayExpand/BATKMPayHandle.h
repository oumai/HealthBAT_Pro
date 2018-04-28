//
//  BATKMPayHandle.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/20.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMTPayApi.h" //康美支付

@interface BATKMPayHandle : NSObject <KMTPayApiDelegate>

+ (BATKMPayHandle *)shareKMPayHandle;

@end
