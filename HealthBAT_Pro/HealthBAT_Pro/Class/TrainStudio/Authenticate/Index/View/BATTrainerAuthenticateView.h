//
//  BATTrainerAuthenticateView.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATTrainerAuthenticateView : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) YYLabel *contentLabel;

@property (nonatomic,strong) UIButton *startBtn;

@property (nonatomic,copy) void(^startBlock)(void);

@end
