//
//  BATHomeTopSearchView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/6/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeTopSearchView : UIView

@property (nonatomic,strong) UIView *roundView;
@property (nonatomic,strong) UIImageView *bImageView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *searchIconImageView;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UIButton *messageBtn;

@property (nonatomic,copy) void(^searchBlock)(void);
@property (nonatomic,copy) void(^messageBlock)(void);

@end
