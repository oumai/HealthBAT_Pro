//
//  BATMemberCenterItemTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATMemberCenterItemTableViewCell.h"

@implementation BATMemberCenterItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.bgView.backgroundColor = [UIColor redColor];
//    self.bgView.layer.cornerRadius = 6.0f;
//    self.bgView.layer.masksToBounds = YES;
    
//    self.payBtn.enablehollowOut = NO;
//    [self.payBtn setGradientColors:@[START_COLOR,END_COLOR]];
//    self.payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.payBtn.layer.cornerRadius = 5.0f;
//    self.payBtn.layer.masksToBounds = YES;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (void)setSellPrice:(NSString *)sellPrice
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:sellPrice];
    
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 1)];
    
    self.sellPriceLabel.attributedText = string;
}

- (void)setOriginalPrice:(NSString *)originalPrice
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:originalPrice];
    
    [string addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(-0.8)} range:NSMakeRange(0, originalPrice.length)];
    
    self.originalPriceLabel.attributedText = string;
}

- (IBAction)payAction:(id)sender
{
    
    if (self.payBlock) {
        self.payBlock(self.cellIndexPath);
    }
    
}

@end
