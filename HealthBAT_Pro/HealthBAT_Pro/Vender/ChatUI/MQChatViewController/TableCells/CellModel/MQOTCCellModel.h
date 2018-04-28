//
//  MQOTCCellModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"
#import "MQOTCMessage.h"

@interface MQOTCCellModel : NSObject <MQCellModelProtocol>

/**
 * @brief cell中消息的id
 */
@property (nonatomic, readonly, strong) NSString *messageId;

/**
 * @brief 用户名字，暂时没用
 */
@property (nonatomic, readonly, copy) NSString *userName;

/**
 * @brief 该cellModel的委托对象
 */
@property (nonatomic, weak) id<MQCellModelDelegate> delegate;

/**
 * @brief cell的高度
 */
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/**
 * @brief cell的宽度
 */
@property (nonatomic, readonly, assign) CGFloat cellWidth;

/**
 * @brief 消息的文字
 */
@property (nonatomic, readonly, copy) NSAttributedString *cellText;

/**
 * @brief 消息的文字属性
 */
@property (nonatomic, readonly, copy) NSDictionary *cellTextAttributes;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readonly, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readonly, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片
 */
@property (nonatomic, readonly, copy) UIImage *avatarImage;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readonly, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readonly, assign) CGRect bubbleImageFrame;

/**
 * @brief 消息气泡中的文字的frame
 */
@property (nonatomic, readonly, assign) CGRect textLabelFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readonly, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readonly, assign) CGRect sendingIndicatorFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readonly, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readonly, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息文字中，数字选中识别的字典 [number : range]
 */
@property (nonatomic, readonly, strong) NSDictionary *numberRangeDic;

/**
 * @brief 消息文字中，url选中识别的字典 [url : range]
 */
@property (nonatomic, readonly, strong) NSDictionary *linkNumberRangeDic;

/**
 * @brief 消息文字中，email选中识别的字典 [email : range]
 */
@property (nonatomic, readonly, strong) NSDictionary *emailNumberRangeDic;



/**
 * @brief 消息的发送状态
 */
@property (nonatomic, assign) MQChatMessageSendStatus sendStatus;

/**
 预约id
 */
@property (nonatomic, copy) NSString *OPDRegisterID;

/**
 处方单url
 */
@property (nonatomic, copy) NSString *RecipeImgUrl;

/**
 处方ID
 */
@property (nonatomic, copy) NSString *RecipeFileID;

/**
 处方编号
 */
@property (nonatomic, copy) NSString *RecipeNo;

/**
 处方名称
 */
@property (nonatomic, copy) NSString *RecipeName;

/**
 金额
 */
@property (nonatomic, copy) NSString *Amount;

/**
 代煎费用单价 元/剂
 */
@property (nonatomic, copy) NSString *ReplacePrice;

/**
 判断是否代煎 0 否，非0是代煎
 */
@property (nonatomic, assign) NSInteger ReplaceDose;

/**
 一共多少剂
 */
@property (nonatomic, assign) NSInteger TCMQuantity;

/**
 *  根据MQMessage内容来生成cell model
 */
- (MQOTCCellModel *)initCellModelWithMessage:(MQOTCMessage *)message
                                    cellWidth:(CGFloat)cellWidth
                                     delegate:(id<MQCellModelDelegate>)delegator;

@end
