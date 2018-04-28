//
//  BATDiteGuideEditTagCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideEditTagCell.h"
#import "UIColor+Gradient.h"

@implementation BATDiteGuideEditTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = UIColorFromHEX(0x888888, 1);
    self.textLabel.layer.borderWidth = 0.5;
    self.textLabel.layer.cornerRadius = 12.5;
    self.textLabel.layer.masksToBounds = YES;
    
}
- (void)setSelected:(BOOL)selected{
    
    UIColor *selTextColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:13];
    self.textLabel.textColor = selected ? selTextColor : UIColorFromHEX(0x888888, 1);

    self.textLabel.layer.borderColor = selected ? selTextColor.CGColor : UIColorFromHEX(0x888888, 1).CGColor;
    
}
@end
