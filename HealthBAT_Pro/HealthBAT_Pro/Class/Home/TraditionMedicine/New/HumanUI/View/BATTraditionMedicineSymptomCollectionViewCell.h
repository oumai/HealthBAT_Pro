//
//  BATTraditionMedicineSymptomCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

@interface BATTraditionMedicineSymptomCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *symptomLabel;

@property (nonatomic,strong) BATGraditorButton *symptomBtn;


- (void)selectCellWithYesAndNo:(BOOL)state;

@end
