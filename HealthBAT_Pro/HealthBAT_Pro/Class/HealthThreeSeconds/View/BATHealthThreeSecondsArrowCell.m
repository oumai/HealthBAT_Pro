//
//  BATHealthThreeSecondsArrowCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsArrowCell.h"
@interface BATHealthThreeSecondsArrowCell ()
@property (weak, nonatomic) IBOutlet UIView *fgView;

@end

@implementation BATHealthThreeSecondsArrowCell
- (IBAction)infoButtonClick:(UIButton *)sender {
    if (self.infoButtonBlock) {
        self.infoButtonBlock();
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rightLabel.textColor = UIColorFromHEX(0x999999, 1);
    self.leftLabel.textColor = UIColorFromHEX(0x333333, 1);
    self.fgView.backgroundColor = UIColorFromHEX(0xdcdcdc, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
