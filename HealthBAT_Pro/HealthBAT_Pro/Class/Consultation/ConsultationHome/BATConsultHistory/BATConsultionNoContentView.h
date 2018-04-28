//
//  BATConsultionNoContentView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATConsultionNoContentView : UIView

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *consultLable;

@property (nonatomic,strong) UIImageView *doctorIconView;

@property (nonatomic,strong) UIView *topLine;

@property (nonatomic,strong) UIImageView *consultionIcon;

@property (nonatomic,strong) BATGraditorButton *descLabel;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UILabel *ellipsisLabel;

@end
