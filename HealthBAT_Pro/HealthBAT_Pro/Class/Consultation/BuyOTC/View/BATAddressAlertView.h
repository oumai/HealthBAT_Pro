//
//  BATAddressAlertView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

typedef void(^CancelBlock)(void);
typedef void(^ConfrimBlock)(void);

@interface BATAddressAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *hLine;
@property (weak, nonatomic) IBOutlet UILabel *vLine;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet BATGraditorButton *confrimButton;

@property (nonatomic,strong) CancelBlock cancelBlock;
@property (nonatomic,strong) ConfrimBlock conrimBlock;

- (void)show;

@end
