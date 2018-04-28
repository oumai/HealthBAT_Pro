//
//  BATTIMService.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BATTIMManager.h"

@protocol BATTIMServiceDelegate <NSObject>

- (void)updateUIWithNewMessage:(NSMutableArray *)message;

@end

@interface BATTIMService : NSObject <TIMMessageListener>

/**
 *  
 */
@property (nonatomic,weak) id<BATTIMServiceDelegate> delegate;

/**
 *  发送文本消息
 *
 *  @param content 文本
 *  @param complete 完成block
 */
+ (void)sendTextMessageWithContent:(NSString *)content complete:(void (^)(BOOL state,TIMMessage *message))complete;

/**
 *  发送图片消息
 *
 *  @param image 图片
 *  @param complete  完成block
 */
+ (void)sendImageMessageWithImage:(UIImage *)image complete:(void (^)(BOOL state,TIMMessage *message))complete;

/**
 *  语音消息
 *
 *  @param audio    语音数据
 *  @param complete 完成block
 */
+ (void)sendAudioMessage:(NSData *)audio complete:(void (^)(BOOL state,TIMMessage *message))complete;

/**
 *  接收消息
 *
 *  @param msgs 消息数组
 */
- (void)onNewMessage:(NSArray *)msgs;

/**
 *  获取当前会话的消息记录
 *
 *  @param count 获取数量
 *  @param last  上次最后一条消息
 *  @param complete 回掉
 */
+ (void)getMessage:(int)count last:(TIMMessage *)last complete:(void (^)(NSMutableArray *msgs))complete;

@end
