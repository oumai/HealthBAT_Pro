//
//  BATHealthThreeSecondsFoodEnterTopInfoView.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsFoodEnterTopInfoView.h"
#import "BATHealthThreeSecondsFoodEnterTopDataModel.h"
@interface BATHealthThreeSecondsFoodEnterTopInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *foodCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageButtonHeightCons;
@end

@implementation BATHealthThreeSecondsFoodEnterTopInfoView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
}

- (void)setTopDataModel:(BATHealthThreeSecondsFoodEnterTopDataModel *)topDataModel{
    _topDataModel = topDataModel;
    self.nameLabel.text = topDataModel.name;
    self.calorieLabel.text = [NSString stringWithFormat:@"%@卡路里",topDataModel.calorie];
    BOOL isHidden = [topDataModel.name isEqualToString:@"非菜"] ? NO : YES;
    self.messageButton.hidden = isHidden;
    self.coverView.hidden = !isHidden;
    self.messageButtonBottomConstraint.constant = isHidden ? 5 : 20;
    self.messageButtonHeightCons.constant = isHidden ? 1 : 15;
}
@end
