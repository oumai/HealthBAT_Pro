//
//  BATDrKangDetailView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/2/212017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDrKangDetailView : UIView

@property (nonatomic,strong) UIButton *downButton;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UITextView *detailTextView;

@property (nonatomic,copy) void(^downBlock)(void);

@end
