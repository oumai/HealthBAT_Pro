//
//  MQOTCMessageCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "MQOTCMessageCell.h"
#import "MQChatFileUtil.h"
#import "MQChatViewConfig.h"
#import "MQBundleUtil.h"
#import "MQOTCCellModel.h"
//#import "MEIQIA_TTTAttributedLabel.h"

//static const NSInteger kMQTextCellSelectedUrlActionSheetTag = 2000;
//static const NSInteger kMQTextCellSelectedNumberActionSheetTag = 2001;
//static const NSInteger kMQTextCellSelectedEmailActionSheetTag = 2002;

@interface MQOTCMessageCell()
//<TTTAttributedLabelDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *data;

@end

@implementation MQOTCMessageCell  {
    UIImageView *avatarImageView;
    UILabel *titleLabel;
    UILabel *descLabel;
    UIImageView *arrowImageView;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendingIndicator;
    UIImageView *failureImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        avatarImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:avatarImageView];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        bubbleImageView.userInteractionEnabled = true;
//        UILongPressGestureRecognizer *longPressBubbleGesture=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBubbleView:)];
//        [bubbleImageView addGestureRecognizer:longPressBubbleGesture];
        
        UITapGestureRecognizer *tapPressBubbleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressBubbleView:)];
        [bubbleImageView addGestureRecognizer:tapPressBubbleGesture];
        
        [self.contentView addSubview:bubbleImageView];
        
        //初始化文字
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.userInteractionEnabled = true;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [bubbleImageView addSubview:titleLabel];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height, 100, 20)];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.userInteractionEnabled = true;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:14];
        descLabel.textColor = UIColorFromHEX(0x999999, 1);
        [bubbleImageView addSubview:descLabel];
        
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(descLabel.frame.origin.x + descLabel.frame.size.width + 5, 0, 7, 11)];
        arrowImageView.userInteractionEnabled = YES;
        arrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        [bubbleImageView addSubview:arrowImageView];
        
        arrowImageView.centerY = descLabel.centerY;

//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//        } else {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
//            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//#pragma clang diagnostic pop
//        }
//        titleLabel.numberOfLines = 0;
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.userInteractionEnabled = true;
//        titleLabel.backgroundColor = [UIColor clearColor];
//        [bubbleImageView addSubview:titleLabel];
        //初始化indicator
        sendingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendingIndicator.hidden = YES;
        [self.contentView addSubview:sendingIndicator];
        //初始化出错image
        failureImageView = [[UIImageView alloc] initWithImage:[MQChatViewConfig sharedConfig].messageSendFailureImage];
        UITapGestureRecognizer *tapFailureImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFailImage:)];
        failureImageView.userInteractionEnabled = true;
        [failureImageView addGestureRecognizer:tapFailureImageGesture];
        [self.contentView addSubview:failureImageView];
        
        
        _data = [[NSMutableDictionary alloc] init];

        
    }
    return self;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQOTCCellModel class]]) {
        NSAssert(NO, @"传给MQOTCMessageCell的Model类型不正确");
        return ;
    }
    MQOTCCellModel *cellModel = (MQOTCCellModel *)model;
    
    //刷新头像
    if (cellModel.avatarImage) {
        avatarImageView.image = cellModel.avatarImage;
    }
    avatarImageView.frame = cellModel.avatarFrame;
    if ([MQChatViewConfig sharedConfig].enableRoundAvatar) {
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = cellModel.avatarFrame.size.width/2;
    }
    
    //刷新气泡
    bubbleImageView.image = cellModel.bubbleImage;
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    
    //刷新indicator
    sendingIndicator.hidden = true;
    [sendingIndicator stopAnimating];
    if (cellModel.sendStatus == MQChatMessageSendStatusSending && cellModel.cellFromType == MQChatCellOutgoing) {
        sendingIndicator.hidden = false;
        sendingIndicator.frame = cellModel.sendingIndicatorFrame;
        [sendingIndicator startAnimating];
    }
    
    //记录需要传出去的数据
    [_data removeAllObjects];
    [_data setObject:cellModel.OPDRegisterID forKey:@"OPDRegisterID"];
    [_data setObject:cellModel.RecipeImgUrl forKey:@"RecipeImgUrl"];
    [_data setObject:cellModel.RecipeFileID forKey:@"RecipeFileID"];
    [_data setObject:cellModel.RecipeNo forKey:@"RecipeNo"];
    [_data setObject:cellModel.RecipeName forKey:@"RecipeName"];
    [_data setObject:cellModel.Amount forKey:@"Amount"];
    [_data setObject:@(cellModel.ReplaceDose) forKey:@"ReplaceDose"];
    [_data setObject:cellModel.ReplacePrice forKey:@"ReplacePrice"];
    [_data setObject:@(cellModel.TCMQuantity) forKey:@"TCMQuantity"];
    
    //刷新聊天文字
//    titleLabel.frame = cellModel.textLabelFrame;
    titleLabel.text = @"处方单";
//    descLabel.frame = cellModel.
    descLabel.text = @"点击查看详情";
//    if ([textLabel isKindOfClass:[UILabel class]]) {
//        titleLabel.text = cellModel.cellText;
//    } else {
//        titleLabel.text = cellModel.cellText;
//    }
//    //获取文字中的可选中的元素
//    if (cellModel.numberRangeDic.count > 0) {
//        NSString *longestKey = @"";
//        for (NSString *key in cellModel.numberRangeDic.allKeys) {
//            //找到最长的key
//            if (key.length > longestKey.length) {
//                longestKey = key;
//            }
//        }
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//            [textLabel addLinkToPhoneNumber:longestKey withRange:[cellModel.numberRangeDic[longestKey] rangeValue]];
//        }
//    }
//    if (cellModel.linkNumberRangeDic.count > 0) {
//        NSString *longestKey = @"";
//        for (NSString *key in cellModel.linkNumberRangeDic.allKeys) {
//            //找到最长的key
//            if (key.length > longestKey.length) {
//                longestKey = key;
//            }
//        }
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//            [textLabel addLinkToURL:[NSURL URLWithString:longestKey] withRange:[cellModel.linkNumberRangeDic[longestKey] rangeValue]];
//        }
//    }
//    if (cellModel.emailNumberRangeDic.count > 0) {
//        NSString *longestKey = @"";
//        for (NSString *key in cellModel.emailNumberRangeDic.allKeys) {
//            //找到最长的key
//            if (key.length > longestKey.length) {
//                longestKey = key;
//            }
//        }
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//            [textLabel addLinkToTransitInformation:@{@"email" : longestKey} withRange:[cellModel.emailNumberRangeDic[longestKey] rangeValue]];
//        }
//    }
    
    //刷新出错图片
    failureImageView.hidden = true;
    if (cellModel.sendStatus == MQChatMessageSendStatusFailure) {
        failureImageView.hidden = false;
        failureImageView.frame = cellModel.sendFailureFrame;
    }
}

//#pragma TTTAttributedLabelDelegate 点击事件
//- (void)attributedLabel:(TTTAttributedLabel *)label
//didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber
//                atPoint:(CGPoint)point {
//    [self showMenueController];
//}
//
//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:phoneNumber delegate:self cancelButtonTitle:[MQBundleUtil localizedStringForKey:@"alert_view_cancel"] destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"%@%@", [MQBundleUtil localizedStringForKey:@"make_call_to"], phoneNumber], [NSString stringWithFormat:@"%@%@", [MQBundleUtil localizedStringForKey:@"send_message_to"], phoneNumber], [MQBundleUtil localizedStringForKey:@"save_text"], nil];
//    sheet.tag = kMQTextCellSelectedNumberActionSheetTag;
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//}
//
//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:[MQBundleUtil localizedStringForKey:@"alert_view_cancel"] destructiveButtonTitle:nil otherButtonTitles:[MQBundleUtil localizedStringForKey:@"open_url_by_safari"], [MQBundleUtil localizedStringForKey:@"save_text"], nil];
//    sheet.tag = kMQTextCellSelectedUrlActionSheetTag;
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//}
//
//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
//    if (!components[@"email"]) {
//        return ;
//    }
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:components[@"email"] delegate:self cancelButtonTitle:[MQBundleUtil localizedStringForKey:@"alert_view_cancel"] destructiveButtonTitle:nil otherButtonTitles:[MQBundleUtil localizedStringForKey:@"make_email_to"], [MQBundleUtil localizedStringForKey:@"save_text"], nil];
//    sheet.tag = kMQTextCellSelectedEmailActionSheetTag;
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//}
//
//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:MQChatViewKeyboardResignFirstResponderNotification object:nil];
//    switch (actionSheet.tag) {
//        case kMQTextCellSelectedNumberActionSheetTag: {
//            NSLog(@"点击了一个数字");
//            switch (buttonIndex) {
//                case 0:
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", actionSheet.title]]];
//                    break;
//                case 1:
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", actionSheet.title]]];
//                    break;
//                case 2:
//                    [UIPasteboard generalPasteboard].string = actionSheet.title;
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
//        case kMQTextCellSelectedUrlActionSheetTag: {
//            NSLog(@"点击了一个url");
//            switch (buttonIndex) {
//                case 0: {
//                    if ([actionSheet.title rangeOfString:@"://"].location == NSNotFound) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", actionSheet.title]]];
//                    } else {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
//                    }
//                    break;
//                }
//                case 1:
//                    [UIPasteboard generalPasteboard].string = actionSheet.title;
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
//        case kMQTextCellSelectedEmailActionSheetTag: {
//            NSLog(@"点击了一个email");
//            switch (buttonIndex) {
//                case 0: {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", actionSheet.title]]];
//                    break;
//                }
//                case 1:
//                    [UIPasteboard generalPasteboard].string = actionSheet.title;
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    //通知界面点击了消息
//    if (self.chatCellDelegate) {
//        if ([self.chatCellDelegate respondsToSelector:@selector(didSelectMessageInCell:messageContent:selectedContent:)]) {
//            [self.chatCellDelegate didSelectMessageInCell:self messageContent:self.textLabel.text selectedContent:actionSheet.title];
//        }
//    }
//}

//#pragma 长按事件
//- (void)longPressBubbleView:(id)sender {
//    if (((UILongPressGestureRecognizer*)sender).state == UIGestureRecognizerStateBegan) {
//        [self showMenueController];
//    }
//}

#pragma mark 点击处方
- (void)tapPressBubbleView:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BATClickOTCMessageNotification object:_data];
}

//- (void)showMenueController {
//    [self showMenuControllerInView:self targetRect:bubbleImageView.frame menuItemsName:@{@"textCopy" : textLabel.text}];
//
//}

#pragma 点击发送失败消息，重新发送事件
- (void)tapFailImage:(id)sender {
//
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重新发送吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重新发送吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.chatCellDelegate resendMessageInCell:self resendData:@{@"text" : textLabel.text}];
//    }];
//
//    [alertController addAction:cancelAction];
//    [alertController addAction:confirmAction];
//
//    [[Tools getPresentedViewController] presentViewController:alertController animated:YES completion:nil];
}

//#pragma UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        NSLog(@"重新发送");
//        [self.chatCellDelegate resendMessageInCell:self resendData:@{@"text" : textLabel.text}];
//    }
//}


@end
