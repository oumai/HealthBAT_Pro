//
//  BATDoctorServiceBottomView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

@interface BATDoctorServiceBottomView : UIView

@property (strong, nonatomic) BATGraditorButton *severStartBtn;

@property (nonatomic,strong) void (^startSeverTap)(void);

@end
