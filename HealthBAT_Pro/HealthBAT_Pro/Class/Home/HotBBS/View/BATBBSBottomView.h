//
//  BATBBSBottomView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATBBSBottomView : UIView

@property (nonatomic,strong) UIButton *editButton;

@property (nonatomic,copy) void(^editBlock)();

@end
