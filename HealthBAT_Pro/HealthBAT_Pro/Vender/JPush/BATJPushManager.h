//
//  BATJPushManager.h
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATJPushManager : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (BATJPushManager *)sharedJPushManager;

- (void)setAlias:(NSString *)alias;

@end
