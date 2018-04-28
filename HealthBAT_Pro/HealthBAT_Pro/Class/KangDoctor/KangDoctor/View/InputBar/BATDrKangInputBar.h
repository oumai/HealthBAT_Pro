//
//  BATDrKangInputBar.h
//  HealthBAT_Pro
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATDrKangInputBar : UIView

@property (nonatomic,strong) UIButton *changeButton;
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic,strong) UIButton *soundInputButton;
@property (nonatomic,strong) UIButton *notiBtn;

@property (nonatomic,copy) void(^sendTextMessageBlock)(void);

@property (nonatomic,copy) void(^changeInputModeBlock)(void);

@property (nonatomic,copy) void(^recognizerBeginBlock)(void);
@property (nonatomic,copy) void(^recognizerStopBlock)(void);
@property (nonatomic,copy) void(^recognizerAlertBlock)(void);
@property (nonatomic,copy) void(^recognizerCancelBlock)(void);
@property (nonatomic,copy) void(^recognizerContinueBlock)(void);

@end
