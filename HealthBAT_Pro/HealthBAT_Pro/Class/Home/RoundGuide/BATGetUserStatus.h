//
//  BATGetUserStatus.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, guideStatus){
    
    greenStatus = 0, //默认 男 < 35 和 未登录
    pinkStatus, //女2 > 35
    cyanStatus, //女1 < 35
    blueStatus //男1 > 35
    
};
@interface BATGetUserStatus : NSObject

@property (assign, nonatomic) guideStatus userStatus;

- (NSString *)changeStringByStatusWithString:(NSString *)nowString;
- (UIColor *)changeTitleColor;
@end
