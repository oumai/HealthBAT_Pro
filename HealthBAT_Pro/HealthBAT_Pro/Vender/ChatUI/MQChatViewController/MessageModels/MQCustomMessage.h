//
//  MQCustomMessage.h
//  HealthBAT_Pro
//
//  Created by KM on 16/11/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "MQBaseMessage.h"

@interface MQCustomMessage : MQBaseMessage

/** 消息content */
@property (nonatomic, copy) NSString *content;

/**
 * 用文字初始化message
 */
- (instancetype)initWithContent:(NSString *)content;

@end
