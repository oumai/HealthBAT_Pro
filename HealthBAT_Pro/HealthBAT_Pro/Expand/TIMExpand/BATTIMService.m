//
//  BATTIMService.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTIMService.h"
#import "MQTextMessage.h"
#import "MQVoiceMessage.h"
#import "MQImageMessage.h"
#import "BATFaceManager.h"
#import "MQFaceMessage.h"
#import "MQOTCMessage.h"
#import "YYText.h"
#import <YYImage/YYImage.h>
#import "BATPerson.h"
//#import "BATLoginModel.h"
#import "BATTIMDataModel.h"

@implementation BATTIMService

+ (void)sendTextMessageWithContent:(NSString *)content complete:(void (^)(BOOL,TIMMessage *))complete
{
    TIMTextElem *text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:content];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    
    [[BATTIMManager sharedBATTIM] bat_sendMessage:msg success:^{
        
        DDLogDebug(@"发送成功");
        
        if (complete) {
            complete(YES,msg);
        }
        
    } failure:^(int code, NSString *msg) {
        DDLogDebug(@"发送失败");
        
        if (complete) {
            complete(NO,nil);
        }
    }];

}

//==============================
// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight 190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth 66.f

+ (void)sendImageMessageWithImage:(UIImage *)image complete:(void (^)(BOOL,TIMMessage *))complete
{
    
    CGFloat scale = 1;
    scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
    
    CGFloat picHeight = image.size.height;
    CGFloat picWidth = image.size.width;
    NSInteger picThumbHeight = (NSInteger) (picHeight * scale + 1);
    NSInteger picThumbWidth = (NSInteger) (picWidth * scale + 1);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    BOOL isDirectory = NO;
    NSError *err = nil;
    
    // 当前sdk仅支持文件路径上传图片，将图片存在本地
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err])
        {
            DDLogDebug(@"Upload Image Failed: same upload filename: %@", err);
            return;
        }
    }
    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 1) attributes:nil])
    {
        DDLogDebug(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return;
    }
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f_ThumbImage", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    UIImage *thumbImage = [Tools imageWithImageSimple:image scaledToSize:CGSizeMake(picThumbWidth, picThumbHeight)];
    if (![fileManager createFileAtPath:thumbPath contents:UIImageJPEGRepresentation(thumbImage, 1) attributes:nil])
    {
        DDLogDebug(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return;
    }
    
    TIMImageElem *image_elem = [[TIMImageElem alloc] init];
    image_elem.path = filePath;
    image_elem.level = TIM_IMAGE_COMPRESS_HIGH;
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:image_elem];
    
    [[BATTIMManager sharedBATTIM] bat_sendMessage:msg success:^{
        
        DDLogDebug(@"发送成功");
        
        if (complete) {
            complete(YES,msg);
        }
        
    } failure:^(int code, NSString *msg) {
        DDLogDebug(@"发送失败");
        
        if (complete) {
            complete(NO,nil);
        }
    }];
}

+ (void)sendAudioMessage:(NSData *)audio complete:(void (^)(BOOL,TIMMessage *))complete
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f.wav", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    
    BOOL isDirectory = NO;
    NSError *err = nil;
    
    // 当前sdk仅支持文件路径上传图片，将图片存在本地
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err])
        {
            DDLogDebug(@"Upload Image Failed: same upload filename: %@", err);
        }
    }
    if (![fileManager createFileAtPath:filePath contents:audio attributes:nil])
    {
        DDLogDebug(@"Upload Image Failed: fail to create uploadfile: %@", err);
    }
    
    TIMSoundElem *sound_elem = [[TIMSoundElem alloc] init];
    sound_elem.path = filePath;
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:sound_elem];
    
    [[BATTIMManager sharedBATTIM] bat_sendMessage:msg success:^{
        
        DDLogDebug(@"发送成功");
        
        if (complete) {
            complete(YES,msg);
        }
        
    } failure:^(int code, NSString *msg) {
        DDLogDebug(@"发送失败");
        
        if (complete) {
            complete(NO,nil);
        }
    }];
}

- (void)onNewMessage:(NSArray *)msgs
{
    DDLogDebug(@"msgs %@",msgs);
    //一：消息提醒，主要针对咨询的消息提醒
    
    //获取未读消息标识数组
    NSArray *oldArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelIDArray"];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:oldArr];
//    DDLogInfo(@"已存储的标识===%@===",newArr);
    
    //获取当前的房间ID
    NSString *oldRoom = [[NSUserDefaults standardUserDefaults] objectForKey:@"TalkRoomIDDefaults"];
    
    for (NSInteger i=0;i<msgs.count;i++) {
        
        TIMMessage *message = msgs[i];
        
        TIMConversation *conversation = [message getConversation];
        
        NSString *channelID = [NSString stringWithFormat:@"%@",conversation];
        
//        DDLogInfo(@"聊天室消息===%@===",channelID);
        
        //当前房间号和会话标识一致的时候，不存储
        if([oldRoom isEqualToString:channelID]){
            break;
        }else if(![oldRoom isEqualToString:channelID] && i==msgs.count - 1){
            //比到最后一个了，还是不一致
            
            if (newArr.count == 0) {
                [newArr addObject:channelID];
            }else{
                //开始判断是否添加标识
                for (NSInteger j=0;j<newArr.count;j++) {
                    
                    NSString *oldChannelID = newArr[j];
                    
                    if([channelID isEqualToString:oldChannelID]){
                        break;
                    }else if (![channelID isEqualToString:oldChannelID] && j == newArr.count - 1) {
                        //比较到数组最后一个还没有重复，这添加会话
                        //同个订单的消息，不重复标识，查看后会清除这个标识
                        [newArr addObject:channelID];
                    }
                }
            }
        }
    }
    
//    DDLogInfo(@"新存储的标识===%@===",newArr);
    
    if (newArr.count > 0) {
        
        //加通知，刷新提醒标志
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Get_New_Message_From_Doctor" object:nil];
        
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        
        //消息中心角标变化
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_APNS_MESSAGE" object:nil];
    }
    
    //保存到本地
    NSUserDefaults *channleDefaults = [NSUserDefaults standardUserDefaults];
    [channleDefaults setObject:newArr forKey:@"channelIDArray"];
    [channleDefaults synchronize];
    
    
    
    
    
    //二：消息解析，主要针对聊天
    BATTIMDataModel *TIMData = LOGIN_TIM_INFO;
    BATPerson *person = PERSON_INFO;

    NSMutableArray *messages = [NSMutableArray array];
    
    for (TIMMessage *message in msgs) {
        
        int cnt = [message elemCount];
        
        if (cnt > 1) {
            
            BATFaceManager *faceManager = [BATFaceManager shared];
            
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            
            for (int i = 0; i < cnt; i++) {
                
                TIMElem * elem = [message getElem:i];
                
                if ([elem isKindOfClass:[TIMTextElem class]]) {
                    
                    TIMTextElem *textElem = (TIMTextElem *)elem;
                    
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:textElem.text]];
                    
                } else if ([elem isKindOfClass:[TIMFaceElem class]]) {
                    TIMFaceElem *faceElem = (TIMFaceElem *)elem;
                    
//                    UIImage *faceImage = [faceManager faceWithIndex:faceElem.index];
                    
                    NSData *face = [faceManager faceDataWithIndex:faceElem.index];
                    YYImage *image = [YYImage imageWithData:face];
                    image.preloadAllAnimatedImageFrames = YES;
                    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                    
                    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"  "]];
                    [text appendAttributedString: attachment];
                    [text appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"  "]];
                }
            }
            
            MQFaceMessage *faceMessage = [[MQFaceMessage alloc] initWithContent:text];
            faceMessage.messageId = message.msgId;
            faceMessage.fromType = MQChatMessageIncoming;
            faceMessage.date = message.timestamp;
            [messages addObject:faceMessage];
            
        } else {
            TIMElem * elem = [message getElem:0];
            
            if ([elem isKindOfClass:[TIMTextElem class]]) {
                
                TIMTextElem *textElem = (TIMTextElem *)elem;
                
                MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:textElem.text];
                textMessage.messageId = message.msgId;
                if ([message.sender isEqualToString:TIMData.Data.identifier]) {
                    textMessage.fromType = MQChatMessageOutgoing;
                    textMessage.userAvatarPath = person.Data.PhotoPath;
                    textMessage.sendStatus = MQChatMessageSendStatusSuccess;
                }
                else {
                    textMessage.fromType = MQChatMessageIncoming;
                }
                textMessage.date = message.timestamp;
                [messages addObject:textMessage];
                
            } else if ([elem isKindOfClass:[TIMImageElem class]]) {
                TIMImageElem *imageElem = (TIMImageElem *)elem;
                
                //遍历所有图片规格(缩略图、大图、原图)
                NSArray * imgList = [imageElem imageList];
                
                NSString *orginPath = nil;
                NSString *thumbPath = nil;
                
                for (TIMImage * image in imgList) {
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
                        image.url = [image.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    } else {
                        image.url = [image.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                    
                    
//                    NSRange range = [image.url rangeOfString:@"http://upload.jkbat.com"];
//                    
//                    if (range.location != NSNotFound) {
//                        
//                        image.url = [image.url substringFromIndex:range.location];
//                    }
                    
                    
                    if (image.type == TIM_IMAGE_TYPE_THUMB) {
                        
                        thumbPath = image.url;
                        
//                        MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:image.url];
//                        imageMessage.messageId = message.msgId;
//                        imageMessage.fromType = MQChatMessageIncoming;
//                        [messages addObject:imageMessage];
//
//                        break;
                    } else if (image.type == TIM_IMAGE_TYPE_ORIGIN) {
                        orginPath = image.url;
                    }
                    
                }
                
                MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:thumbPath orginPath:orginPath];
                imageMessage.messageId = message.msgId;

                if ([message.sender isEqualToString:TIMData.Data.identifier]) {
                    imageMessage.fromType = MQChatMessageOutgoing;
                    imageMessage.userAvatarPath = person.Data.PhotoPath;
                    imageMessage.sendStatus = MQChatMessageSendStatusSuccess;

                }
                else {
                    imageMessage.fromType = MQChatMessageIncoming;
                }

                imageMessage.date = message.timestamp;
                [messages addObject:imageMessage];

                
            } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
                TIMSoundElem *soundElem = (TIMSoundElem *)elem;
                
                MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoicePath:soundElem.path];
                voiceMessage.messageId = message.msgId;
                voiceMessage.fromType = MQChatMessageIncoming;
                voiceMessage.date = message.timestamp;
                [messages addObject:voiceMessage];
            } else if ([elem isKindOfClass:[TIMFaceElem class]]) {
                TIMFaceElem *faceElem = (TIMFaceElem *)elem;
                
                BATFaceManager *faceManager = [BATFaceManager shared];
                
//                UIImage *faceImage = [faceManager faceWithIndex:faceElem.index];
                
                NSData *face = [faceManager faceDataWithIndex:faceElem.index];
                YYImage *image = [YYImage imageWithData:face];
                image.preloadAllAnimatedImageFrames = YES;
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                
                [text appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter]];
                
                MQFaceMessage *faceMessage = [[MQFaceMessage alloc] initWithContent:text];
                faceMessage.messageId = message.msgId;
                faceMessage.fromType = MQChatMessageIncoming;
                faceMessage.date = message.timestamp;
                [messages addObject:faceMessage];
            }else if ([elem isKindOfClass:[TIMCustomElem class]]) {
                TIMCustomElem * customElem = (TIMCustomElem * )elem;
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {
                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    DDLogError(@"%@",dic);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CUSTOM_MESSAGE" object:self userInfo:dic];
                }
                
                //处方单的自定义消息
                if ([customElem.ext isEqualToString:@"Order.Buy.Recipe"] || [customElem.ext isEqualToString:@"Recipe.Preview"]) {
                    
                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    
                    //网络医院的数据格式不是特别的合理，现在只能这么写 数据返回的是数组
                    NSDictionary *dic = nil;
                    if ([content isKindOfClass:[NSArray class]]) {
                        NSArray *temp = content;
                        
                        if (temp.count > 0 && temp.count == 1) {
                            
                            dic = temp[0];
                            
                        }
                        
                    } else if ([content isKindOfClass:[NSDictionary class]]) {
                        dic = content;
                    }
                    
                    if (dic == nil) {
                        DDLogDebug(@"处方消息数据格式出错，或者出现变化！");
                        return;
                    }
                    
                    
                    DDLogError(@"%@",dic);
                    
                    MQOTCMessage *otcMessage = [[MQOTCMessage alloc] initWithContent:dic];
                    otcMessage.messageId = message.msgId;
                    otcMessage.date = message.timestamp;
                    if (message.isSelf) {
                        otcMessage.fromType = MQChatMessageOutgoing;
                        otcMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                        BATPerson *person = PERSON_INFO;
                        otcMessage.userAvatarPath = person.Data.PhotoPath;
                    } else {
                        otcMessage.fromType = MQChatMessageIncoming;
                    }
                    [messages addObject:otcMessage];
                    
                }

                //服务结束
                if ([customElem.ext isEqualToString:@"Room.Hangup"]) {
                    NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
                    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    DDLogError(@"%@",dic);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CUSTOM_MESSAGE_Room.Hangup" object:self userInfo:dic];
                }

#pragma clang diagnostic pop
                
            }

        }
        
        
//        for (int i = 0; i < cnt; i++) {
//            
//            TIMElem * elem = [message getElem:i];
//            
//            if ([elem isKindOfClass:[TIMTextElem class]]) {
//                
//                TIMTextElem *textElem = (TIMTextElem *)elem;
//                
//                MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:textElem.text];
//                textMessage.messageId = message.msgId;
//                textMessage.fromType = MQChatMessageIncoming;
//                [messages addObject:textMessage];
//                
//            } else if ([elem isKindOfClass:[TIMImageElem class]]) {
//                TIMImageElem *imageElem = (TIMImageElem *)elem;
//                
//                //遍历所有图片规格(缩略图、大图、原图)
//                NSArray * imgList = [imageElem imageList];
//                
//                for (TIMImage * image in imgList) {
//                    
//                    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
//                        image.url = [image.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                    } else {
//                        image.url = [image.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    }
//                    
//                    
//                    if (image.type == TIM_IMAGE_TYPE_THUMB) {
//                        MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:image.url];
//                        imageMessage.messageId = message.msgId;
//                        imageMessage.fromType = MQChatMessageIncoming;
//                        [messages addObject:imageMessage];
//                    }
//        
//                }
//                
//            } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
//                TIMSoundElem *soundElem = (TIMSoundElem *)elem;
//                
//                MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoicePath:soundElem.path];
//                voiceMessage.messageId = message.msgId;
//                voiceMessage.fromType = MQChatMessageIncoming;
//                [messages addObject:voiceMessage];
//            }          else if ([elem isKindOfClass:[TIMFaceElem class]]) {
//                TIMFaceElem *faceElem = (TIMFaceElem *)elem;
//                
////                MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoicePath:soundElem.path];
////                voiceMessage.messageId = message.msgId;
////                voiceMessage.fromType = MQChatMessageIncoming;
////                [messages addObject:voiceMessage];
//            }
//        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUIWithNewMessage:)]) {
        [_delegate updateUIWithNewMessage:messages];
    }
    
}

+ (void)getMessage:(int)count last:(TIMMessage *)last complete:(void (^)(NSMutableArray *msgs))complete;
{
    
    NSMutableArray *messages = [NSMutableArray array];
    
    [[BATTIMManager sharedBATTIM].currentConversation getMessage:count last:last succ:^(NSArray *msgs) {
        
        DDLogDebug(@"msgs %@",msgs);
        
        for (NSInteger i = msgs.count - 1; i >= 0; i--) {
            
            TIMMessage *message = msgs[i];
            
            int cnt = [message elemCount];
            
            if (cnt > 1) {
                
                BATFaceManager *faceManager = [BATFaceManager shared];
                
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                
                for (int i = 0; i < cnt; i++) {
                    
                    TIMElem * elem = [message getElem:i];
                    
                    if ([elem isKindOfClass:[TIMTextElem class]]) {
                        
                        TIMTextElem *textElem = (TIMTextElem *)elem;
                        
                        [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:textElem.text]];
                        
                    } else if ([elem isKindOfClass:[TIMFaceElem class]]) {
                        TIMFaceElem *faceElem = (TIMFaceElem *)elem;

                        NSData *face = [faceManager faceDataWithIndex:faceElem.index];
                        YYImage *image = [YYImage imageWithData:face];
                        image.preloadAllAnimatedImageFrames = YES;
                        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                        
                        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
                        
                        [text appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"  "]];
                        [text appendAttributedString: attachment];
                        [text appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"  "]];
                    }
                }
                
                MQFaceMessage *faceMessage = [[MQFaceMessage alloc] initWithContent:text];
                faceMessage.messageId = message.msgId;
                faceMessage.date = message.timestamp;
                if (message.isSelf) {
                    faceMessage.fromType = MQChatMessageOutgoing;
                    faceMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                    BATPerson *person = PERSON_INFO;
                    faceMessage.userAvatarPath = person.Data.PhotoPath;
                } else {
                    faceMessage.fromType = MQChatMessageIncoming;
                }
                [messages addObject:faceMessage];
                
            } else {
                TIMElem * elem = [message getElem:0];
                
                if ([elem isKindOfClass:[TIMTextElem class]]) {
                    
                    TIMTextElem *textElem = (TIMTextElem *)elem;
                    
                    MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:textElem.text];
                    textMessage.messageId = message.msgId;
                    textMessage.date = message.timestamp;
                    if (message.isSelf) {
                        textMessage.fromType = MQChatMessageOutgoing;
                        textMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                        BATPerson *person = PERSON_INFO;
                        textMessage.userAvatarPath = person.Data.PhotoPath;
                    } else {
                        textMessage.fromType = MQChatMessageIncoming;
                    }
                    [messages addObject:textMessage];
                    
                } else if ([elem isKindOfClass:[TIMImageElem class]]) {
                    TIMImageElem *imageElem = (TIMImageElem *)elem;
                    
                    //遍历所有图片规格(缩略图、大图、原图)
                    NSArray * imgList = [imageElem imageList];
                    
                    NSString *orginPath = nil;
                    NSString *thumbPath = nil;
                    
                    for (TIMImage * image in imgList) {
                        
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
                            image.url = [image.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        } else {
                            image.url = [image.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        }
                        
//                        NSRange range = [image.url rangeOfString:@"http://upload.jkbat.com"];
//                        
//                        if (range.location != NSNotFound) {
//                            
//                            image.url = [image.url substringFromIndex:range.location];
//                        }
                        
                        
                        if (image.type == TIM_IMAGE_TYPE_THUMB) {
                            
                            thumbPath = image.url;
                            
//                            MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:image.url];
//                            imageMessage.messageId = message.msgId;
//                            if (message.isSelf) {
//                                imageMessage.fromType = MQChatMessageOutgoing;
//                                imageMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
//                            } else {
//                                imageMessage.fromType = MQChatMessageIncoming;
//                            }
//
//                            [messages addObject:imageMessage];
//
//                            break;
                        } else if (image.type == TIM_IMAGE_TYPE_ORIGIN) {
                            orginPath = image.url;
                        }
                        
                    }
                    
                    MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:thumbPath orginPath:orginPath];
                    imageMessage.messageId = message.msgId;
                    imageMessage.date = message.timestamp;
                    if (message.isSelf) {
                        imageMessage.fromType = MQChatMessageOutgoing;
                        imageMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                        BATPerson *person = PERSON_INFO;
                        imageMessage.userAvatarPath = person.Data.PhotoPath;
                    } else {
                        imageMessage.fromType = MQChatMessageIncoming;
                    }
                    
                    [messages addObject:imageMessage];

                    
                } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
                    TIMSoundElem *soundElem = (TIMSoundElem *)elem;
                    
                    MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoicePath:soundElem.path];
                    voiceMessage.messageId = message.msgId;
                    voiceMessage.soundElem = soundElem;
                    voiceMessage.date = message.timestamp;
                    if (message.isSelf) {
                        voiceMessage.fromType = MQChatMessageOutgoing;
                        voiceMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                        BATPerson *person = PERSON_INFO;
                        voiceMessage.userAvatarPath = person.Data.PhotoPath;
                    } else {
                        voiceMessage.fromType = MQChatMessageIncoming;
                    }
                    [messages addObject:voiceMessage];
                } else if ([elem isKindOfClass:[TIMFaceElem class]]) {
                    TIMFaceElem *faceElem = (TIMFaceElem *)elem;
                    
                    BATFaceManager *faceManager = [BATFaceManager shared];
                    
//                    UIImage *faceImage = [faceManager faceWithIndex:faceElem.index];
                    
                    NSData *face = [faceManager faceDataWithIndex:faceElem.index];
                    YYImage *image = [YYImage imageWithData:face];
                    image.preloadAllAnimatedImageFrames = YES;
                    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                    
                    NSMutableAttributedString *text = [NSMutableAttributedString new];
                    
                    [text appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter]];
                    
                    MQFaceMessage *faceMessage = [[MQFaceMessage alloc] initWithContent:text];
                    faceMessage.messageId = message.msgId;
                    faceMessage.date = message.timestamp;
                    if (message.isSelf) {
                        faceMessage.fromType = MQChatMessageOutgoing;
                        faceMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                        BATPerson *person = PERSON_INFO;
                        faceMessage.userAvatarPath = person.Data.PhotoPath;
                    } else {
                        faceMessage.fromType = MQChatMessageIncoming;
                    }
                    [messages addObject:faceMessage];
                } else if ([elem isKindOfClass:[TIMCustomElem class]]) {
                    TIMCustomElem * customElem = (TIMCustomElem * )elem;
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {

                    }
                    
                    //处方单的自定义消息
                    if ([customElem.ext isEqualToString:@"Order.Buy.Recipe"] || [customElem.ext isEqualToString:@"Recipe.Preview"]) {
                        
                        NSString *string = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
                        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                        id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        
                        
                        //网络医院的数据格式不是特别的合理，现在只能这么写 数据返回的是数组
                        NSDictionary *dic = nil;
                        if ([content isKindOfClass:[NSArray class]]) {
                            NSArray *temp = content;
                            
                            if (temp.count > 0 && temp.count == 1) {
                                
                                dic = temp[0];
                                
                            }
                            
                        } else if ([content isKindOfClass:[NSDictionary class]]) {
                            dic = content;
                        }
                        
                        if (dic == nil) {
                            DDLogDebug(@"处方消息数据格式出错，或者出现变化！");
                            return;
                        }
                        
                        DDLogError(@"%@",dic);
                        
                        MQOTCMessage *otcMessage = [[MQOTCMessage alloc] initWithContent:dic];
                        otcMessage.messageId = message.msgId;
                        otcMessage.date = message.timestamp;
                        if (message.isSelf) {
                            otcMessage.fromType = MQChatMessageOutgoing;
                            otcMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
                            BATPerson *person = PERSON_INFO;
                            otcMessage.userAvatarPath = person.Data.PhotoPath;
                        } else {
                            otcMessage.fromType = MQChatMessageIncoming;
                        }
                        [messages addObject:otcMessage];
                    }
                    
                    //服务结束
                    if ([customElem.ext isEqualToString:@"Room.Hangup"]) {
       
                    }
                    
#pragma clang diagnostic pop
                }
            }
            
//            for (int i = 0; i < cnt; i++) {
//                TIMElem * elem = [message getElem:i];
//                
//                if ([elem isKindOfClass:[TIMTextElem class]]) {
//                    
//                    TIMTextElem *textElem = (TIMTextElem *)elem;
//                    
//                    MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:textElem.text];
//                    textMessage.messageId = message.msgId;
//                    
//                    if (message.isSelf) {
//                        textMessage.fromType = MQChatMessageOutgoing;
//                        textMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
//                    } else {
//                        textMessage.fromType = MQChatMessageIncoming;
//                    }
//
//                    [messages addObject:textMessage];
//                    
//                } else if ([elem isKindOfClass:[TIMImageElem class]]) {
//                    TIMImageElem *imageElem = (TIMImageElem *)elem;
//                    
//                    //遍历所有图片规格(缩略图、大图、原图)
//                    NSArray * imgList = [imageElem imageList];
//                    
//                    for (TIMImage * image in imgList) {
//                        
//                        if (image.type == TIM_IMAGE_TYPE_THUMB) {
//                            
//                            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
//                                image.url = [image.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                            } else {
//                                image.url = [image.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                            }
//                            
//                            MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:image.url];
//                            imageMessage.messageId = message.msgId;
//                            if (message.isSelf) {
//                                imageMessage.fromType = MQChatMessageOutgoing;
//                                imageMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
//                            } else {
//                                imageMessage.fromType = MQChatMessageIncoming;
//                            }
//                            [messages addObject:imageMessage];
//                        }
//                        
//                    }
//                    
//                } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
//                    TIMSoundElem *soundElem = (TIMSoundElem *)elem;
//                    
//                    MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoiceData:soundElem.data];
//                    voiceMessage.messageId = message.msgId;
//                    voiceMessage.soundElem = soundElem;
//                    if (message.isSelf) {
//                        voiceMessage.fromType = MQChatMessageOutgoing;
//                        voiceMessage.sendStatus = message.status == TIM_MSG_STATUS_SEND_SUCC ? MQChatMessageSendStatusSuccess : MQChatMessageSendStatusFailure;
//                    } else {
//                        voiceMessage.fromType = MQChatMessageIncoming;
//                    }
//                    [messages addObject:voiceMessage];
//                    
//
//                }
//                
//            }
        }
        
        if (complete) {
            complete(messages);
        }
        

        
    } fail:^(int code, NSString *msg) {
        DDLogDebug(@"msg %@, code %d",msg,code);
        
        if (complete) {
            complete(messages);
        }
    }];
}

@end
