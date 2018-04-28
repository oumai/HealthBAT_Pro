//
//  TitleTableViewCell.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTitleTableViewCell.h"
#import "Masonry.h"

@implementation BATTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = UIColorFromHEX(0x333333, 1);
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
    }
    return self;
}

@end
