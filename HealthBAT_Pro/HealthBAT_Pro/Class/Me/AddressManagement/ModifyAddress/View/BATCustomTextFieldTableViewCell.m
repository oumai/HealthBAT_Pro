//
//  BATCustomNormalTableViewCell.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCustomTextFieldTableViewCell.h"

@implementation BATCustomTextFieldTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

@end
