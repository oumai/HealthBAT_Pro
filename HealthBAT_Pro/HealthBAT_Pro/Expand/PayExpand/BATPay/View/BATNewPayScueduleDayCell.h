//
//  BATNewPayScueduleDayCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATNewPayScueduleDayCell : UICollectionViewCell


@property (nonatomic,strong) UILabel *timeLable;

@property (nonatomic,strong) UIImageView *leftImageIcon;

@property (nonatomic,strong) UIView *leftView;

@property (nonatomic,strong) UIView *rightView;

@property (nonatomic,strong) UIImageView *rightImageIcon;

@property (nonatomic,copy) void(^clickLeftImageIcon)(void);
@property (nonatomic,copy) void(^clickRightImageIcon)(void);
@end
