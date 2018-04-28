//
//  BATJPushManager.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATJPushManager.h"

@implementation BATJPushManager

+ (BATJPushManager *)sharedJPushManager {

    static BATJPushManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATJPushManager alloc] init];
    });
    return instance;
}

- (void)setAlias:(NSString *)alias {

//    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        if (!iResCode) {
            iResCode = 0;
        }
//        if (!tags) {
//            tags = [NSSet set];
//        }
        if (!iAlias) {
            iAlias = @"nil";
        }
        if (iResCode != 0) {
            
            //重新设置别名
            [self bk_performBlock:^(id obj) {
                
                [[BATJPushManager sharedJPushManager] setAlias:alias];
            } afterDelay:60];
        }
        
        //记录错误日志
        NSDictionary *dic = @{
                              @"Action":@"极光推送设置别名",
                              @"alias":iAlias,
//                              @"tags":[tags allObjects],
                              @"Code":[NSString stringWithFormat:@"%ld",(long)iResCode]
                              };
        
        BOOL isWriteSuccess = [Tools errorWriteLocationWithData:dic];
        if (isWriteSuccess) {
            DDLogDebug(@"写入成功");
        }
    } seq:123];
}

//回调
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (!iResCode) {
        iResCode = 0;
    }
    if (!tags) {
        tags = [NSSet set];
    }
    if (!alias) {
        alias = @"nil";
    }
    if (iResCode != 0) {

        //重新设置别名
        [self bk_performBlock:^(id obj) {

            [[BATJPushManager sharedJPushManager] setAlias:alias];
        } afterDelay:60];
    }
    
    //记录错误日志
    NSDictionary *dic = @{
                          @"Action":@"极光推送设置别名",
                          @"alias":alias,
                          @"tags":[tags allObjects],
                          @"Code":[NSString stringWithFormat:@"%d",iResCode]
                          };
    
    BOOL isWriteSuccess = [Tools errorWriteLocationWithData:dic];
    if (isWriteSuccess) {
        DDLogDebug(@"写入成功");
    }

}

@end
