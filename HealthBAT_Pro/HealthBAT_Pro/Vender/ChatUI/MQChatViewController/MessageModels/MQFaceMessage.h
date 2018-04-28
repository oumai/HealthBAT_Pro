//
//  MQFaceMessage.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "MQBaseMessage.h"
#import "YYText.h"

@interface MQFaceMessage : MQBaseMessage

/** 消息content */
@property (nonatomic, strong) NSMutableAttributedString *content;

/**
 * 用文字初始化message
 */
- (instancetype)initWithContent:(NSMutableAttributedString *)content;

@end
