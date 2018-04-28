//
//  BATFileListController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@interface BATFileListController : UIViewController
@property(nonatomic,strong)void (^ChooseBlock)(ChooseTreatmentModel *model);
@end
