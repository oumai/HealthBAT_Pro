//
//  BATDoctorFilterFooterView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
typedef void(^DoctorFilterFooterConfrimBlock)(void);

@interface BATDoctorFilterFooterView : UIView

@property (nonatomic,strong) BATGraditorButton *confrimButton;

@property (nonatomic,strong) DoctorFilterFooterConfrimBlock doctorFilterFooterConfrimBlock;

@end
