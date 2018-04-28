//
//  BATHealthEvaluationContentView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseContentBlock)(void);

@interface BATHealthEvaluationContentView : UIView

@property (nonatomic,strong) UIControl *control;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) CloseContentBlock closeContentBlock;

@end
