//
//  HomeHeaderCollectionReusableView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeHeaderView : UIView
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *changeButton; //换一换按钮


@property (nonatomic,copy) void(^leftTap  ) (void);
@property (nonatomic,copy) void(^middleTap) (void);
@property (nonatomic,copy) void(^rightTap ) (void);

@end
