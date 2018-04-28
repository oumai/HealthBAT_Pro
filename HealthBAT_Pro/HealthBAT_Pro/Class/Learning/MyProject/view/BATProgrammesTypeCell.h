//
//  BATProgrammesTypeCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgrammesTypeModel.h"
#import "BATGraditorButton.h"
@interface BATProgrammesTypeCell : UITableViewCell

@property (nonatomic,strong) BATGraditorButton *titleLb;

@property (nonatomic,strong) ProgrammesType *typeModel;
@end
