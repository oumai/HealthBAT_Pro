//
//  BATHealthThreeSecondsCameraCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsCameraCell.h"
@interface BATHealthThreeSecondsCameraCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraTitleLabel;

@end
@implementation BATHealthThreeSecondsCameraCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.calorieLabel.textColor = UIColorFromHEX(0x666666, 1);
    self.titleLabel.textColor = UIColorFromHEX(0x999999, 1);
    self.cameraTitleLabel.textColor = UIColorFromHEX(0x999999, 1);
    
}

- (IBAction)cameraButtonClick:(UIButton *)sender {
    if (self.cameraButtonClick) {
        self.cameraButtonClick();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
