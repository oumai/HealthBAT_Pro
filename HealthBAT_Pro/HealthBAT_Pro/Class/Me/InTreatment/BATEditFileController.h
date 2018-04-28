//
//  BATEditFileController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@interface BATEditFileController : UIViewController
@property (nonatomic,strong) ChooseTreatmentModel *model;
@property(nonatomic,strong)void (^RefreshBlock)(void);
@end
