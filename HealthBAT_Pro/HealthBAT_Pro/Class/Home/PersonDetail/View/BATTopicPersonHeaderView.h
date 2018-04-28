//
//  BATTopicPersonHeaderView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTopicPersonHeaderView : UIView
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//关注按钮
@property (strong, nonatomic)  UIButton *AttendBtn;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (nonatomic,strong) void (^attendAction)();
@end
