//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>

#import "MZTimerLabel.h"
#import "BATGraditorButton.h"

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *topBlueView;

@property (nonatomic,strong) UILabel *remindLabel;

@property (nonatomic,strong) UILabel *consultLable;

@property (nonatomic,strong) BATGraditorButton *consultTimeLable;

@property (nonatomic,strong) UIImageView *doctorIconView;

@property (nonatomic,strong) UILabel *doctorNameLabel;

@property (nonatomic,strong) UILabel *countDownTimeLabel;
@property (nonatomic,strong) UILabel *countDownLabel;
@property (nonatomic,strong) MZTimerLabel *countMZTimeLabel;

@property (nonatomic,strong) UILabel *describeLabel;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UIImageView *remindView;

@property (nonatomic,copy) void(^remindViewClick)(void);

@end
