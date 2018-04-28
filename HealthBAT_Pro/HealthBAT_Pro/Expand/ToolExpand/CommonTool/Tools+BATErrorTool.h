//
//  Tools+BATErrorTool.h
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "Tools.h"

@interface Tools (BATErrorTool)

+ (NSMutableDictionary *)errorDic;

+ (BOOL)errorWriteLocationWithData:(NSDictionary *)dic;

@end
