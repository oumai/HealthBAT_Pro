//
//  BATLoginAllianceView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATLoginAllianceView : UIView

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *littleBackView;
@property (nonatomic,strong) UIImageView *kmImageVIew;
@property (nonatomic,strong) UILabel *mobileLabel;;
@property (nonatomic,strong) BATGraditorButton *loginBtn;

@property (nonatomic,copy) void(^downBlock)(void);
@property (nonatomic,copy) void(^loginBlock)(void);

@end
