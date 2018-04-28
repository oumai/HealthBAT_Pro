//
//  BATAlbumDetailBottomView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputBlock)(void);

@interface BATAlbumDetailBottomView : UIView

/**
 背景
 */
@property (nonatomic,strong) UIView *bgView;

/**
 评论icon
 */
@property (nonatomic,strong) UIImageView *iconImageView;

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 触发按钮
 */
@property (nonatomic,strong) UIButton *button;

/**
 输入Block
 */
@property (nonatomic,strong) InputBlock inputBlock;

@end
