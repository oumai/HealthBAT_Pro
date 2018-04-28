//
//  leftTabCell.h
//  BATmySelfIntreatmentController
//
//  Created by kmcompany on 16/10/9.
//  Copyright © 2016年 kmcompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSelfDiagnosisModel.h"
#import "BATGraditorButton.h"
@interface leftTabCell : UITableViewCell
@property (nonatomic,strong) BATGraditorButton *nameLb;
@property (nonatomic,strong) Partsitemlist *model;
@end
