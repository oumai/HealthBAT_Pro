//
//  BATConfirmPayCouponCodeTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/22017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConfirmPayCouponCodeTableViewCell : UITableViewCell

@property (nonatomic,strong) UITextField *inputTF;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,copy) void(^confirmCouponCodeBlock)(NSString *couponCode);

@end
