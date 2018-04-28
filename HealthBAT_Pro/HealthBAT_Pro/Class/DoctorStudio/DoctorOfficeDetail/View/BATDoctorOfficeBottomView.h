//
//  BATDoctorOfficeBottomView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorOfficeBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *severTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *severStartLb;

@property (nonatomic,strong) void (^startSeverTap)();

@end
