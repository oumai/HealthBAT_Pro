//
//  BATDoctorOfficeBottomView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorOfficeBottomView.h"

@interface BATDoctorOfficeBottomView()


@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation BATDoctorOfficeBottomView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.severTypeLb.textColor = UIColorFromHEX(0X333333, 1);
    self.severStartLb.backgroundColor = BASE_COLOR;
    self.severStartLb.textColor = UIColorFromHEX(0Xffffff, 1);
    
    UITapGestureRecognizer *startTap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startAction)];
    self.severStartLb.userInteractionEnabled = YES;
    [self.severStartLb addGestureRecognizer:startTap];
}

- (void)startAction {

    if (self.startSeverTap) {
        self.startSeverTap();
    }
}


@end
