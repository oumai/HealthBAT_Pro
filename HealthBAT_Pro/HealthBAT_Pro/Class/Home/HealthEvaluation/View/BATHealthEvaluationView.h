//
//  BATHealthEvaluationView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "BATSportsDietView.h"
#import "BATPsychologicalSocietyView.h"
#import "BATHealthEvaluationContentView.h"

@interface BATHealthEvaluationView : UIView

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UILabel *pgLabel;

@property (nonatomic,strong) UILabel *jyLabel;

@property (nonatomic,strong) UIImageView *topMenuBgView;

@property (nonatomic,strong) UIButton *sljkBtn;

@property (nonatomic,strong) UIButton *xljkBtn;

@property (nonatomic,strong) UIButton *shjkBtn;

@property (nonatomic,strong) HMSegmentedControl *segmentedControl;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) BATSportsDietView *sportsDietView;//运动，饮食

@property (nonatomic,strong) BATPsychologicalSocietyView *psychologicalSocietyView;

@property (nonatomic,strong) BATHealthEvaluationContentView *contentView; //评估

@end
