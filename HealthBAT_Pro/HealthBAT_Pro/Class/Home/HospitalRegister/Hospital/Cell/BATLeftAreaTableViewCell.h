//
//  BATLeftAreaTableViewCell.h
//  HealthBAT_Pro
//
//  Created by four on 16/10/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
@interface BATLeftAreaTableViewCell : UITableViewCell

@property (nonatomic,strong) BATGraditorButton *nameLb;

@property (nonatomic,strong) BATGraditorButton *lineView;

@property (nonatomic,strong) UIView *backView;

@end
