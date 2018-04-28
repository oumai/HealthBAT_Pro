//
//  BATFindTitleCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindTitleCell.h"

@implementation BATFindTitleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

@end
