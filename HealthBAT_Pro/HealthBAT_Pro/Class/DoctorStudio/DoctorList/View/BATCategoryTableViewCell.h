//
//  BATCategoryTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
@interface BATCategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) BATGraditorButton *titleLabel;

@property (nonatomic,strong) UIView *selectBgView;

@property (nonatomic,strong) BATGraditorButton *blueLine;

@end
