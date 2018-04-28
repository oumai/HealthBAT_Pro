//
//  MQInputBar.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-28.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEIQIA_HPGrowingTextView.h"
#import "MQNamespacedDependencies.h"
#import "MQChatTableView.h"
#import "BATMoreView.h"

@protocol MQInputBarDelegate <NSObject>
@optional
-(BOOL)sendTextMessage:(NSString*)text;
-(void)sendImageWithSourceType:(UIImagePickerControllerSourceType)sourceType;
-(void)inputting:(NSString*)content;

-(void)beginRecord:(CGPoint)point;
-(void)finishRecord:(CGPoint)point;
-(void)cancelRecord:(CGPoint)point;
-(void)changedRecordViewToCancel:(CGPoint)point;
-(void)changedRecordViewToNormal:(CGPoint)point;
-(void)chatTableViewScrollToBottom;
@end

@interface MQInputBar : UIView <BATMoreViewDelegate>

@property(nonatomic, weak) id<MQInputBarDelegate> delegate;
@property(nonatomic, strong) HPGrowingTextView* textView;

- (id)initWithFrame:(CGRect)frame
          superView:(UIView *)inputBarSuperView
          tableView:(MQChatTableView *)tableView
    enableSendVoice:(BOOL)enableVoice
    enableSendImage:(BOOL)enableImage
   photoSenderImage:(UIImage *)photoImage
photoHighlightedImage:(UIImage *)photoHighlightedImage
   voiceSenderImage:(UIImage *)voiceImage
voiceHighlightedImage:(UIImage *)voiceHighlightedImage
keyboardSenderImage:(UIImage *)keyboardImage
keyboardHighlightedImage:(UIImage *)keyboardHighlightedImage
resignKeyboardImage:(UIImage *)resignKeyboardImage
resignKeyboardHighlightedImage:(UIImage *)resignKeyboardHighlightedImage;

- (id)initWithFrame:(CGRect)frame
          superView:(UIView *)inputBarSuperView
          tableView:(MQChatTableView *)tableView
           moreView:(BATMoreView *)moreView
    enableSendVoice:(BOOL)enableVoice
    enableSendImage:(BOOL)enableImage
   photoSenderImage:(UIImage *)photoImage
photoHighlightedImage:(UIImage *)photoHighlightedImage
   voiceSenderImage:(UIImage *)voiceImage
voiceHighlightedImage:(UIImage *)voiceHighlightedImage
keyboardSenderImage:(UIImage *)keyboardImage
keyboardHighlightedImage:(UIImage *)keyboardHighlightedImage
resignKeyboardImage:(UIImage *)resignKeyboardImage
resignKeyboardHighlightedImage:(UIImage *)resignKeyboardHighlightedImage;

- (id)initWithFrame:(CGRect)frame
          superView:(UIView *)inputBarSuperView
          tableView:(MQChatTableView *)tableView
    isSearchDisease:(BOOL)isSearchDisease
    enableSendVoice:(BOOL)enableVoice
    enableSendImage:(BOOL)enableImage
   photoSenderImage:(UIImage *)photoImage
photoHighlightedImage:(UIImage *)photoHighlightedImage
   voiceSenderImage:(UIImage *)voiceImage
voiceHighlightedImage:(UIImage *)voiceHighlightedImage
keyboardSenderImage:(UIImage *)keyboardImage
keyboardHighlightedImage:(UIImage *)keyboardHighlightedImage
resignKeyboardImage:(UIImage *)resignKeyboardImage
resignKeyboardHighlightedImage:(UIImage *)resignKeyboardHighlightedImage;

/** 更新frame */
- (void)updateFrame:(CGRect)frame;

@end