//
//  BATHealthThreeSecondsDrinkWateRecordCell.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsDrinkWateRecordCell.h"
#import "BATPerson.h"
@interface BATHealthThreeSecondsDrinkWateRecordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *addWateButton;
@property (nonatomic, strong) BATPerson *loginUserModel;
@property (nonatomic, assign) NSInteger maxDrinkWateCount;

@end
@implementation BATHealthThreeSecondsDrinkWateRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.wateCountLabel.textColor = UIColorFromHEX(0x999999, 1);
    self.loginUserModel = PERSON_INFO;
    
//   _maxDrinkWateCount = self.loginUserModel.Data.Weight > 200 ? 15 : 12;
    _maxDrinkWateCount  = 25;
}

/**
 加
 */
- (IBAction)addWartButtonClick:(UIButton *)button {
   
    self.drinkingWaterCount ++  ;
    if (self.drinkWateButtonBlock) {
        self.drinkWateButtonBlock(self.drinkingWaterCount);
    }
    
}
/**
 减
 */
- (IBAction)reduceButtonClick:(UIButton *)sender {
    
    self.drinkingWaterCount = (self.drinkingWaterCount) > _maxDrinkWateCount ? _maxDrinkWateCount : self.drinkingWaterCount;
    if (self.drinkingWaterCount) {   // 减
        self.drinkingWaterCount -- ;
        self.wateCountLabel.text = [NSString stringWithFormat:@"x  %ld",(long)self.drinkingWaterCount];
        
        if (self.drinkWateButtonBlock) {
            self.drinkWateButtonBlock(self.drinkingWaterCount);
        }
    }
    
}


@end
