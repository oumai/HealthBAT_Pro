//
//  ZYExceptionHandler.h
//  ZYExceptionDemo
//
//  Created by 1 on 15/3/31.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchExceptionHandler : NSObject
+ (void)caughtExceptionHandler;

#define ExceptionHandler [CatchExceptionHandler caughtExceptionHandler];

@end
