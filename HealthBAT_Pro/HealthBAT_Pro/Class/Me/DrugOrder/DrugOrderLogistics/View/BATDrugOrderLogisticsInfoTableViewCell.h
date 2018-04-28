//
//  BATDrugOrderLogisticsInfoTableViewCell.h
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATDrugOrderLogisticsInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *leftTitleLabel;
@property (nonatomic,strong) BATGraditorButton *queryBtn;

@property (nonatomic,copy) void(^queryBlock)(void);

@end
