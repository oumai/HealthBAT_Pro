//
//  Tools+BATErrorTool.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "Tools+BATErrorTool.h"

@implementation Tools (BATErrorTool)

+ (NSMutableDictionary *)errorDic {

    if ([[NSFileManager defaultManager] fileExistsAtPath:locationErrorData]) {
        NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithContentsOfFile:locationErrorData];
        return dic;
    }

    return [NSMutableDictionary dictionary];
}

+ (BOOL)errorWriteLocationWithData:(NSDictionary *)dic {

    NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
    if ([[NSFileManager defaultManager] fileExistsAtPath:locationErrorData]) {
        errorDic= [NSMutableDictionary dictionaryWithContentsOfFile:locationErrorData];
    }

    [errorDic setObject:dic forKey:[Tools getStringFromDate:[NSDate date]]];
    BOOL isSuccess = [errorDic writeToFile:locationErrorData atomically:YES];
    return isSuccess;
}

@end
