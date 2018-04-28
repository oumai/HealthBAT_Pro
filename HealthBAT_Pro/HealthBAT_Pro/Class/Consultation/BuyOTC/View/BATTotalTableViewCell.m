//
//  BATTotalTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTotalTableViewCell.h"

@implementation BATTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)totalPrice:(NSString *)string
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColorFromHEX(0xf94f4f, 1)} range:NSMakeRange(3, string.length - 3)];
    
    self.totalPriceLabel.attributedText = attributeString;
}

@end
