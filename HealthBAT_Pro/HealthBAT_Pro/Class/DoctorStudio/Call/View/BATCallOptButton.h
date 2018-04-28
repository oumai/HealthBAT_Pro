//
//  BATCallOptButton.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BATCallOptBlock)(void);

@interface BATCallOptButton : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) BATCallOptBlock callOptBlock;

@end
