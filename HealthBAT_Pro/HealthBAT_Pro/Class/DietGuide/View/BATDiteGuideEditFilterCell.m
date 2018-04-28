//
//  BATDiteGuideEditFilterCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideEditFilterCell.h"
#import "UIColor+Gradient.h"

@implementation BATDiteGuideEditFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
- (void)setSelected:(BOOL)selected{
    UIColor *sleColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:12];
    self.titleLabel.textColor = selected ? sleColor : UIColorFromHEX(0x333333, 1);
}
@end
