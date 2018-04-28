//
//  RegisterFooterView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
@interface BATRegisterFooterView : UIView

@property (nonatomic,copy) void(^confirmRegister)(void);
@property (nonatomic,strong) BATGraditorButton *confirmButton;

@end
