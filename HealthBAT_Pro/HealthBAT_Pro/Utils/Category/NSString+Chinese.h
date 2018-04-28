//
//  NSString+Chinese.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Chinese)


/**
 是否为纯中文

 @return YES纯中文
 */
- (BOOL)isChinese;


/**
 是否包含中文

 @return YES包含
 */
- (BOOL)includeChinese;
@end
