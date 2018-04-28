//
//  BATNewPaybottomView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"


@interface BATNewPaybottomView : UIView


/**
 *  确认付款按钮
 */
@property (nonatomic,strong) BATGraditorButton *confirmPayBtn;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *descLabel;

@end
