//
//  BATConfirmPayHeaderView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/22017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConfirmPayHeaderView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *selcetedBtn;
@property (nonatomic,copy) void(^selectCouponCodeBlock)(BOOL isSelect);

@end
