//
//  MQCustomMessage.m
//  HealthBAT_Pro
//
//  Created by KM on 16/11/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "MQCustomMessage.h"

@implementation MQCustomMessage

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        self.content = content;
    }
    return self;
}

@end
