//
//  BATDoctorSortFooterView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
typedef void(^DoctorSortFooterConfrimBlock)(void);

@interface BATDoctorSortFooterView : UIView

@property (nonatomic,strong) BATGraditorButton *confrimButton;

@property (nonatomic,strong) DoctorSortFooterConfrimBlock doctorSortFooterConfrimBlock;

@end
