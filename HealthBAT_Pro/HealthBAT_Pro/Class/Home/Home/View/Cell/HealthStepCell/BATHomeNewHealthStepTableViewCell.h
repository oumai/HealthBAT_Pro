//
//  BATHomeNewHealthStepTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/5/102017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHomeHealthStepLeftView.h"
#import "BATHomeHealthStepRightView.h"

@interface BATHomeNewHealthStepTableViewCell : UITableViewCell

@property (nonatomic,strong) BATHomeHealthStepLeftView *leftView;
@property (nonatomic,strong) BATHomeHealthStepRightView *calView;
@property (nonatomic,strong) BATHomeHealthStepRightView *fatView;

@end
