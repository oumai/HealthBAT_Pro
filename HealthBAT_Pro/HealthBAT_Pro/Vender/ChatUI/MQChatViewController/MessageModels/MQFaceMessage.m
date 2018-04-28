//
//  MQFaceMessage.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "MQFaceMessage.h"

@implementation MQFaceMessage

- (instancetype)initWithContent:(NSMutableAttributedString *)content {
    if (self = [super init]) {
        self.content = content;
    }
    return self;
}

@end
