//
//  BATPaySuccessHeaderView.h
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATPaySuccessHeaderView : UIView

/**
 *  支付状态imageView
 */
@property (nonatomic,strong) UIImageView *statusImageView;

/**
 *  支付状态
 */
@property (nonatomic,strong) BATGraditorButton *statusLabel;

@end
