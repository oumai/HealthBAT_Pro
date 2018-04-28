//
//  BATSendCommentView.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATSendCommentView : UIView

@property (nonatomic,strong) YYTextView *commentTextView;
@property (nonatomic,strong) UIButton *sendCommentButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *sendBGView;
@property (nonatomic,strong) UIView *claerBGView;

@property (nonatomic,copy) void(^sendBlock)(void);
@property (nonatomic,copy) void(^claerBlock)(void);

@end
