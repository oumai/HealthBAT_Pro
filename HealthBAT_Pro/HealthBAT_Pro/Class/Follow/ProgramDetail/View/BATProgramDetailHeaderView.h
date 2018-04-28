//
//  BATProgramDetailHeaderView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

typedef void(^JoinProgramBlock)(void);

typedef void(^ExecutePointsBlock)(void);

@interface BATProgramDetailHeaderView : UIView

/**
 背景image
 */
@property (nonatomic,strong) UIImageView *bgView;

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 参加人数
 */
@property (nonatomic,strong) UILabel *countLabel;

/**
 加入方案
 */
@property (nonatomic,strong) BATGraditorButton *joinProgramButton;

/**
 执行要点
 */
@property (nonatomic,strong) UIButton *executePointsButton;

@property (nonatomic,strong) JoinProgramBlock joinProgramBlock;

@property (nonatomic,strong) ExecutePointsBlock executePointsBlock;

@end
