//
//  BATHealthThreeSecondsFoodEnterCell.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsFoodEnterCell.h"
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
#import "BATHealthThreeSecondsDetailListModel.h"

@interface BATHealthThreeSecondsFoodEnterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;

@end

@implementation BATHealthThreeSecondsFoodEnterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.foodNameLabel.textColor = UIColorFromHEX(0x666666, 1);
    self.calorieLabel.textColor = UIColorFromHEX(0x999999, 1);
    
}

- (void)setRecommedFoodModel:(BATHealthThreeSecondsRecommedFoodListModel *)recommedFoodModel{
    _recommedFoodModel = recommedFoodModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:recommedFoodModel.PictureURL] placeholderImage:nil];
    self.foodNameLabel.text = recommedFoodModel.MenuName;
    self.calorieLabel.text = [NSString stringWithFormat:@"%@卡路里",recommedFoodModel.HeatQty];
}

- (void)setThreeSecondsDetailListModel:(BATHealthThreeSecondsDetailListModel *)threeSecondsDetailListModel{
    _threeSecondsDetailListModel = threeSecondsDetailListModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:threeSecondsDetailListModel.ImageUrl] placeholderImage:nil];
    self.foodNameLabel.text = threeSecondsDetailListModel.FoodName;
    self.calorieLabel.text = [NSString stringWithFormat:@"%@卡路里",threeSecondsDetailListModel.Calories];
    
}
@end
