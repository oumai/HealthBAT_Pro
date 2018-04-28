//
//  BATDiteGuideBottomSegementView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideBottomSegementView.h"
#import "UIColor+Gradient.h"
@interface BATDiteGuideBottomSegementView ()

@end
@implementation BATDiteGuideBottomSegementView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromHEX(0xf7f7f7, 1);
    self.rightButton.backgroundColor = UIColorFromHEX(0xf7f7f7, 1);
    self.leftButton.backgroundColor = UIColorFromHEX(0xf7f7f7, 1);
    
}
- (IBAction)leftButtonClick:(UIButton *)leftButton {
    if (self.leftButtonBlock) {
        self.leftButtonBlock(leftButton, self.rightButton);
    }
    
}


- (IBAction)rightButtonClick:(UIButton *)rightButton {
    if (self.rightButtonBlock) {
        self.rightButtonBlock(rightButton, self.leftButton);
    }
}
@end
