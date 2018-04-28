//
//  BATGoHomeView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/8/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATGoHomeView : UIView

@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,copy) void(^tapped)(void);
@end
