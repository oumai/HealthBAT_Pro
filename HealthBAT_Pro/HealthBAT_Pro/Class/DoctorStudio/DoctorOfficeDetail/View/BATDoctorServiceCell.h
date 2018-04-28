//
//  BATDoctorServiceCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

@interface BATDoctorServiceCell : UITableViewCell

@property (strong, nonatomic) UIImageView *chatBG;
@property (strong, nonatomic) UIImageView *audioBG;
@property (strong, nonatomic) UIImageView *videoBG;

@property (strong, nonatomic) UIView *chatClickBG;
@property (strong, nonatomic) UIView *audioClickBG;
@property (strong, nonatomic) UIView *videoClickBG;

@property (strong, nonatomic)  UIImageView *chatImage;
@property (strong, nonatomic)  UIImageView *audioimage;
@property (strong, nonatomic)  UIImageView *videoImage;

@property (strong, nonatomic)  BATGraditorButton *chatTipicLb;
@property (strong, nonatomic)  BATGraditorButton *AudioTipicLb;
@property (strong, nonatomic)  BATGraditorButton *VideoTipicLb;

@property (strong, nonatomic)  BATGraditorButton *chatContentLb;
@property (strong, nonatomic)  BATGraditorButton *AudioContentLb;
@property (strong, nonatomic)  BATGraditorButton *ViedoContentLb;

@property (nonatomic,strong) void (^SeverTapBlock)(NSInteger tag);

@end
