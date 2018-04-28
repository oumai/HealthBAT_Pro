//
//  BATPsychologicalSocietyView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthEvalutionModel.h"
@interface BATPsychologicalSocietyView : UIView
@property (strong, nonatomic) BATHealthEvalutionModel *model;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic, copy) NSString *helpStrig;
@end
