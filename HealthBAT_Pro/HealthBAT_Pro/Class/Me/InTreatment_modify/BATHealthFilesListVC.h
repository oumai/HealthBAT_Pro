//
//  BATHealthFilesViewController.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTreatmentModel.h"
@interface BATHealthFilesListVC : UIViewController
@property(nonatomic,strong)void (^ChooseBlock)(ChooseTreatmentModel *model);
@property (nonatomic, assign) BOOL isConsultionAndAppointmentYes;//是咨询、预约挂号，跳转过来的
@end
